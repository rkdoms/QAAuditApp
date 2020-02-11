<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="QAAuditApp.Details" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>



<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>QA Audit Detail Page:</h2>


<div class="modal fade preview-modal" data-backdrop="true" id="preview-modal"  role="dialog" aria-labelledby="preview-modal" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="mediumModalLabel">QA QUERY <button style="font-size: 14px;" type="button" class="btn" id="copySql"><i class="fa fa-copy"></i></button></h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
                <pre>
                    <code style="display: block;top: 30px;" id="sqlCode">
                        select * from [dbo].[QA_Audit_main]
                        select * from [dbo].[QA_Audit_archive_main]

                        select * from [dbo].[QA_Audit_test_data]
                        select * from [dbo].[QA_Audit_archive_test_data]

                        select * from [dbo].[QA_Audit_question]
                        select * from [dbo].[QA_Audit_archive_question]

                        select * from [dbo].[QA_Audit_test_data]
                        select * from [dbo].[QA_Audit_question]
                    </code>
                </pre>
			</div>
			<div class="modal-footer">
			    <button type="button" class="btn btn-primary" data-dismiss="modal">Dismiss</button>
			</div>
		</div>
	</div>
</div>


<br />
    <div id="remainingtime" style="display:none;">
        <div class="progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">                
            </div>        
        </div>
        <b><div id="countdown"></div></b><br />
    </div>
    <div class="row">
        <div class="col-6">
            <b>Last Audit History</b> <button class="btn btn-primary btn-sm">SEE ALL</button>
            <br />
            <br />
            <div style="font-size:10px;">
                <asp:GridView ID="gv_lastest" runat="server" AutoGenerateColumns="False" CssClass="table table-borderless table-striped table-earning no-hand">
                    <Columns>
                        <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                        <asp:TemplateField HeaderText="End Time">   
                            <ItemTemplate>
                                <%# Convert.ToDateTime(Eval("EndTime")) == DateTime.MinValue ? (Convert.ToDateTime(Eval("StartTime")).AddDays(1)).ToString() : Eval("EndTime") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />
                        <asp:TemplateField HeaderText="QA Status">
                            <ItemTemplate>
                                    <%# Eval("SourcePass").ToString() == "True" ? "Passed" : Eval("IsActive").ToString() == "True" ? "Pending": "Failed" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            
        </div>
        <div class="col-6">
             <b>GENERAL INFO</b>
            <br />
            <br />
            <table class="table table-borderless table-striped table-earning">
                <tr>
                <td width="50%">
                    <div>
                        Source Info ID : <asp:Label ID="lb_sourceinfoid" runat="server"></asp:Label>
                    </div>
                    <div>
                        Source Name : <asp:Label ID="lb_sourcename" runat="server"></asp:Label>
                    </div>
                    <div>
                        Source Type : <asp:Label ID="lb_sourcetype" runat="server"></asp:Label>
                    </div> 
                    <div>
                        Last Audited : <asp:Label ID="lb_lastaudited" runat="server"></asp:Label>
                    </div>
                    <div>
                        QA Status : <asp:Label ID="lb_passfail" runat="server"></asp:Label>
                    </div>
                </td>
                </tr>
            </table>
        </div>

    </div>
   

    <br />

    

<b>TEST RECORDS</b><br />
<table class="table table-borderless table-striped table-earning">
    <tr>
        <td width="100%">
            <div>
                <asp:Button ID="btn_start_audit" runat="server" Text="  Start Answering  " CssClass="btn btn-success btn-lg" Visible="false" OnClick="btn_start_audit_Click" />
                <asp:Button ID="btn_end_audit" runat="server" Text="  Finish Answering  " CssClass="btn btn-success btn-lg" style="display:none" OnClick="btn_end_audit_Click" />
            </div>

        </td>
    </tr>
</table>




<obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AllowSorting="false" AllowPaging="false" RowEditTemplateId="IsActiveTmpl" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="false" 
    OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid" ShowFooter="false" Visible="false" EnableTypeValidation="false" AllowRecordSelection="false">
    <ClientSideEvents OnBeforeClientEdit="GetQuestions" />
<Columns>
    <obout:Column DataField="Id" ReadOnly="true" Visible="false" runat="server">
        <TemplateSettings RowEditTemplateControlId="txt_id" RowEditTemplateControlPropertyName="value"  />
    </obout:Column>	
    <obout:Column DataField="SourceInfoId" ReadOnly="true" Visible="false" runat="server"/>
    <obout:Column DataField="QuestionJson" Visible="false" runat="server">
        <TemplateSettings RowEditTemplateControlId="txt_jsonquestions" RowEditTemplateControlPropertyName="value"  />
    </obout:Column>	
    <obout:Column DataField="Names" ReadOnly="true" HeaderText="Names" runat="server" />								               
	<obout:Column DataField="DOB" ReadOnly="true" HeaderText="DOB" runat="server" />
    <obout:Column DataField="CaseNumber" HeaderText="Case Number" ReadOnly="true" runat="server"/>	
<%--            <obout:Column DataField="Origin" ReadOnly="true" runat="server"/>--%>	
    <obout:Column DataField="CreatedOn" HeaderText="Created On" runat="server"/>  
    <obout:Column DataField="SourcePass" HeaderText="Status" runat="server"/> 
    <obout:Column HeaderText="Options" Width="210" AllowEdit="true" AllowDelete="false" runat="server" TemplateId="EditBtnTemplate" EditTemplateId="updateBtnTemplate" />
</Columns>
<TemplateSettings RowEditTemplateId="IsActiveTmpl" />
<Templates>
    <obout:GridTemplate runat="server" ID="EditBtnTemplate">
        <Template>
            <a href="#" data-dismiss="modal" data-backdrop="" data-toggle="modal" data-target="#preview-modal" class="ob_gAL" >Show Query</a>
            |
            <a class="ob_gAL answering" href="javascript: //" onclick="grid1.editRecord(this);hideAnswering();return false;">Answer Questions</a>
            <span class="ob_gAL answering" style="display: none ">Answer Questions</span>
        </Template>
    </obout:GridTemplate>
    <obout:GridTemplate runat="server" ID="updateBtnTemplate">
        <Template>
            <a class="ob_gAL" href="javascript: //" onclick="grid1.cancel();showAnswering();return false;">Cancel</a>
        </Template>
    </obout:GridTemplate>
    <obout:GridTemplate runat="server" ID="IsActiveTmpl">
        <Template>
            <div class="card">
            <div class="card-header">
                QUESTIONS
            </div>
            <div class="card-body card-block">                     
                <asp:TextBox ID="txt_jsonquestions" CssClass="data_jsonquestions" runat="server" style="display:none;"/>   
                <asp:TextBox ID="txt_id" CssClass="data_id" runat="server" style="display:none;"/>     
                <ul id="questions"></ul>
                <div class="form-actions form-group pull-right">
                    <input type="button" value=" Save " onclick="ValidateQuestions()" class="btn btn-success btn-lg" />
                    <input type="button" value=" Cancel " onclick="grid1.cancel(); showAnswering()" class="btn btn-warning btn-lg" /> 
                </div>
                </div>
            </div>
            </form>
            </Template>
    </obout:GridTemplate>		
</Templates>

</obout:Grid>
    <asp:HiddenField id="startTimeActive" runat="server"/>
    <asp:HiddenField id="endTimeActive" runat="server"/>
<script>    
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

    function myFunction() {
        /* Get the text field */
        //var copyText = document.getElementsByClassName("sqlCode");

        /* Select the text field */
        //copyText.select();
        //copyText.setSelectionRange(0, 99999); /*For mobile devices*/

    /* Copy the text inside the text field */

        document.execCommand("copy");

        /* Alert the copied text */
        alert("Copied the text: " + copyText.value);
    }

    var endTimeExists = false;
    function countdownTimer() {
        try {
            var endTime = "<%=endTimeActive.Value%>";
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

    countdownTimer();
    if (endTimeExists) setInterval(countdownTimer, 1000);


    //before call server to save data some validation and searizations are needed
    function ValidateQuestions() {

        var total = $("input[type='radio']").length / 2;
        var checkedRadios = $("input[type='radio']:checked").length;
        var jsonTmpl = '{"Id":__Id__,"QuestionNumber":__QuestionNumber__,"Question":"","VerifiedBy":"","SourcePass":__SourcePass__,"VerifiedOn":"","Notes":"__Notes__"}';

        if (total == checkedRadios) {//validation for pass fail radios
            if (confirm("Do you really want to send this information?") === true) {//confirm before send info                    
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
        } else {// alert all questios need to be answer
            alert("Please select Pass or Fail for every question");
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
            $("#questions").html(li);
        });
            
    }

    function Reload(record) {
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

</script>
<script id="liTemplate" type="text/template">
<div>
    <input type='hidden' value='__QUESTIONNUMBER__' class='data_qno'/>
    <label style='white-space: pre-wrap; color:#2b4c61;' for='cc-payment' class='control-label mb-1' >__QUESTION__</label >
    <input id='notes__ID__' name='notes__ID__' type='text' class='form-control data_notes' aria-required='true' aria-invalid='false' value='__NOTES__' placeholder='NOTES'/>
    <input type='radio' id='r_ok__ID__' name='rq__ID__' value='true' class='data_pass' __CHECKEDTRUE__/><label for='r_ok__ID__'>Passed </label>
    &nbsp
    <input type='radio' id='r_nok__ID__' name='rq__ID__' value='false' class='data_pass' __CHECKEDFALSE__/> <label for='r_nok__ID__'>Failed  </label>
    <hr>
</div>
</script>
</asp:Content>
