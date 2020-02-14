$(function () {

    function setQueryText(val) {
        $("#sqlCode").text(val);
    }

    $("#copySql").on('click', function () {
        var sel, range;
        var el = $("#sqlCode")[0];
        if (window.getSelection && document.createRange) { //Browser compatibility
            sel = window.getSelection();
            if (sel.toString() == '') { //no text selection
                window.setTimeout(function () {
                    range = document.createRange(); //range object
                    range.selectNodeContents(el); //sets Range
                    sel.removeAllRanges(); //remove all ranges from selection
                    sel.addRange(range);//add Range to a Selection.
                    document.execCommand("copy");
                }, 1);
            }
        } else if (document.selection) { //older ie
            sel = document.selection.createRange();
            if (sel.text == '') { //no text selection
                range = document.body.createTextRange();//Creates TextRange object
                range.moveToElementText(el);//sets Range
                range.select(); //make selection.
                document.execCommand("copy");
            }
        }
    });

    var endTimeExists = false;
    function countdownTimer(startime) {
        try {
            var endTime = startime;//"<%=endTimeActive.Value%>";
            //console.log(endTime);
            if (endTime !== "") {

                var time2 = endTime.split(" ");
                var dateSplt2 = time2[0].split("-")
                var timeSplt2 = time2[1].split(":")
                dt4 = new Date("" + dateSplt2[1] + "-" + dateSplt2[0] + "-" + dateSplt2[2] + ", " + timeSplt2[0] + ":" + timeSplt2[1] + ":" + timeSplt2[2]); //audit end
                const difference = +new Date(dt4) - +new Date();
                let remaining = "Time's up!";


                if (difference > 0) {
                    const parts = {
                        days: Math.floor(difference / (1000 * 60 * 60 * 24)),
                        hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
                        minutes: Math.floor((difference / 1000 / 60) % 60),
                        seconds: Math.floor((difference / 1000) % 60)
                    };

                    var totalMins = parts.hours * 60 + parts.minutes
                    var porcent = totalMins * 100 / 1440;
                    $(".progress-bar").attr("style", "width:" + porcent + "%");

                    remaining = Object.keys(parts)
                        .map(part => {
                            if (!parts[part]) return;
                            return `${parts[part]} ${part}`;
                        })
                        .join(" ");
                }

                document.getElementById("countdown").innerHTML = remaining;
                $("#remainingtime").show();
                endTimeExists = true;
            }
        } catch (err) {
            console.log('error ->' + err)
        }

    }

    //before call server to save data some validation and searizations are needed
    function ValidateQuestions() {

        var total = $("input[type='radio']").length / 2;
        var checkedRadios = $("input[type='radio']:checked").length;
        var jsonTmpl = '{"Id":__Id__,"QuestionNumber":__QuestionNumber__,"Question":"","VerifiedBy":"","SourcePass":__SourcePass__,"VerifiedOn":"","Notes":"__Notes__"}';

        if (total == checkedRadios) {//validation for pass fail radios
            Swal.fire({
                title: 'Answering Questions',
                html: "Do you really want to send this information?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Continue'
            }).then((result) => {
                if (result.value) {
                    var jsonList = ''
                    var id = $(".data_id");

                    //iterate through each li (questions)
                    $("#questions div").each(function () {
                        var json = '';
                        var qno = $(this).find(".data_qno");
                        var notes = $(this).find(".data_notes");
                        var passed = $(this).find(".data_pass:checked");
                        //replace values into json template
                        json = jsonTmpl.replace(/__Id__/g, id.val());
                        json = json.replace(/__QuestionNumber__/g, qno.val());
                        json = json.replace(/__Notes__/g, notes.val());
                        json = json.replace(/__SourcePass__/g, passed.val());
                        jsonList += json + ",";
                    });
                    //assign json to my hidden element
                    $(".data_jsonquestions").val("[" + jsonList.substring(0, jsonList.length - 1) + "]");
                    grid1.save();
                }
            });
        } else {// alert all questios need to be answer
            Swal.fire(
                'Error',
                'Please select Pass or Fail for every question',
                'error'
            );
            //alert("Please select Pass or Fail for every question");
        }
    }

    //load questios from ajax/questions
    function GetQuestions(record) {
        //console.log(record);

        $("#questions").html("loading...");
        $.get("/Ajax/Questions?id=" + record.Id, function (data) {
            json = JSON.parse(data)
            var liTmpl = $("#liTemplate").html();

            var li = "";
            $(json).each(function () {
                var q = $(this)[0];
                var row = liTmpl.replace(/__QUESTION__/g, q.Question);
                row = row.replace(/__QUESTIONNUMBER__/g, q.QuestionNumber);
                row = row.replace(/__ID__/g, q.QuestionNumber);
                row = row.replace(/__NOTES__/g, q.Notes);
                if (q.SourcePass) {
                    row = row.replace(/__CHECKEDFALSE__/g, '');
                    row = row.replace(/__CHECKEDTRUE__/g, 'checked="checked"');
                } else {
                    if (q.VerifiedOn != '') {
                        row = row.replace(/__CHECKEDFALSE__/g, 'checked="checked"');
                        row = row.replace(/__CHECKEDTRUE__/g, '');
                    }
                }
                li += row;
            });
            if (li == "") {
                li = "this record has no questions";
                $(".btn.btn-success.btn-lg.btn-save").hide();
            } else $(".btn.btn-success.btn-lg.btn-save").show();
            $("#questions").html(li);
        });

    }

    function Reload(record) {
        var flag = true;
        var i = 0;
        $("table.ob_gBody tbody tr").each(function () {
            var td = $(this).find("td").eq(7);
            //console.log(td.find(".ob_gCd").text());
            if (td.find(".ob_gCd").text() != "True") {
                flag = false;
                return false;
            }
            i++;
        });
        if (flag && i > 0) $("#btn_confirm_end_audit").show();
        //console.log(record);
    }

    //hide answering links
    function hideAnswering() {
        $("a.answering").hide();
        $("span.answering").show();
    }
    //show answering links
    function showAnswering() {
        $("a.answering").show();
        $("span.answering").hide();
    }

    function ValidateStartAudit(StartelementId) {
        Swal.fire({
            title: 'New Audit Process',
            html: "this will create a new audit for 24 hours <br/> set questions to failed <br/> set test records to failed <br/> all data from previous audit is saved in audit History",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Continue'
        }).then((result) => {
            if (result.value) {
                __doPostBack(StartelementId, 'OnClick');
            }
        });
    }

    function ValidateEndAudit(EndelementId) {
        Swal.fire({
            title: 'Close Audit Process',
            html: "this will set this audit to passed <br/> will save questions and test records to history",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Continue'
        }).then((result) => {
            if (result.value) {
                __doPostBack(EndelementId, 'OnClick');
            }
        });
    }
    //calls to functions
    countdownTimer($("#MainContent_endTimeActive").val());
    if (endTimeExists) setInterval(countdownTimer, 1000);
    Reload(null);
    $("#MainContent_gv_lastest span").parent().parent().parent().attr("style", "background:yellow");
});
