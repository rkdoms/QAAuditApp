(function ($) {
    // USE STRICT
    "use strict";
    
    try {
        $.get("Ajax/api?op=AvgFails&vals={'val1':'1','val2':'2'}", function (data) {
            json = JSON.parse(data)
            console.log(json.result.data[0])
            $(".avgf").html(json.result.data[0]+"%")
        });



        //failsPerSource
        var ctx = document.getElementById("pieChart");
        var json = "";
        var source = "";
        var data = "";
        var labels = "";
        $.get("Ajax/api?op=failsPerSource&vals={'val1':'1','val2':'2'}", function (data) {
            console.log(data)
            json = JSON.parse(data)
            
            if (ctx) {

                ctx.height = 200;
                var myChart = new Chart(ctx, {
                    type: 'pie',
                    data: {
                        datasets: [{
                            data: json.result.data,
                            backgroundColor: [
                                "rgba(0, 123, 255,0.9)",
                                "rgba(0, 123, 255,0.7)",
                                "rgba(0, 123, 255,0.5)",
                                "rgba(0,0,0,0.07)"
                            ],
                            hoverBackgroundColor: [
                                "rgba(0, 123, 255,0.9)",
                                "rgba(0, 123, 255,0.7)",
                                "rgba(0, 123, 255,0.5)",
                                "rgba(0,0,0,0.07)"
                            ]

                        }],
                        labels: json.result.source
                    },
                    options: {
                        legend: {
                            position: 'top',
                            labels: {
                                fontFamily: 'Poppins'
                            }

                        },
                        responsive: true
                    }
                });
            }
        });


        //AvgFailsPerSource
        var ctx2 = document.getElementById("avgFailsPerSource");
        var json = "";
        var source = "";
        var data = "";
        var labels = "";
        $.get("Ajax/api?op=AvgFailsPerSource&vals={'val1':'1','val2':'2'}", function (data) {
            
            json = JSON.parse(data)
            if (ctx2) {

                ctx2.height = 200;
                var myChart = new Chart(ctx2, {
                    type: 'pie',
                    data: {
                        datasets: [{
                            data: json.result.data,
                            backgroundColor: [
                                "rgba(0, 123, 255,0.9)",
                                "rgba(0, 123, 255,0.7)",
                                "rgba(0, 123, 255,0.5)",
                                "rgba(0,0,0,0.07)"
                            ],
                            hoverBackgroundColor: [
                                "rgba(0, 123, 255,0.9)",
                                "rgba(0, 123, 255,0.7)",
                                "rgba(0, 123, 255,0.5)",
                                "rgba(0,0,0,0.07)"
                            ]

                        }],
                        labels: json.result.source
                    },
                    options: {
                        legend: {
                            position: 'top',
                            labels: {
                                fontFamily: 'Poppins'
                            }

                        },
                        responsive: true
                    }
                });
            }
        });
        


    } catch (error) {
        console.log(error);
    }

    /*//averageFails
    try {

        //pie chart
        var ctx = document.getElementById("pieChart2");
        var json = "";
        var source = "";
        var data = "";
        var labels = "";
        $.get("Ajax/api?op=averageFails&vals={'val1':'1','val2':'2'}", function (data) {
            $(".avgf").html(data)
        });



    } catch (error) {
        console.log(error);
    }*/
})(jQuery);