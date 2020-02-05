<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="QAAuditApp.Details" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>QA Audit Detail Page:</h2>
    <br />
         <div class="progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                
            </div>
             
        </div>
        <b><div id="countdownToMidnight"></div></b><br />
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
            QC Passed : <asp:Label ID="lb_passfail" runat="server"></asp:Label>
        </div>
    <br />

 
            <obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="true" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid">
			<Columns>
                <obout:Column DataField="Sourceinfoid" ReadOnly="true" Visible="false" runat="server"/>	                
                <obout:Column DataField="VerifiedBy" ReadOnly="true" HeaderText="Verified By" runat="server" />								               
				<obout:Column DataField="VerifiedOn" ReadOnly="true" HeaderText="Verified On" runat="server" />
                <obout:Column DataField="QuestionNumber" HeaderText="Question Number" ReadOnly="true" runat="server"/>	
                <obout:Column DataField="Question" ReadOnly="true" runat="server"/>	
                <obout:CheckBoxColumn DataField="PassFail" HeaderText="Pass/Fail" Width="100" runat="server" TemplateId="IsActiveTmpl" />		
                <obout:Column DataField="Notes" HeaderText="Notes" runat="server"/>
				<obout:Column HeaderText="Options" Width="200" AllowEdit="true" AllowDelete="false" runat="server" />							
			</Columns>
			<Templates>	
                <obout:GridTemplate runat="server" ID="IsActiveTmpl">
                    <Template>
                        <%# Container.Value.ToString() %>               
                    </Template>
                </obout:GridTemplate>		
			</Templates>
		</obout:Grid>
    
	<script>
        window.setInterval(function () {
            ShowTimes();
        }, 1000);


        function diff_hours(dt2, dt1) {

            var diff = (dt2.getTime() - dt1.getTime()) / 1000;
            diff /= (60 * 60);
            return Math.abs(Math.round(diff));

        }
        function ShowTimes() {
            var lastAudited = $("#<%=lb_lastaudited.ClientID%>").text();
            var time = lastAudited.split(" ");
            var dateSplt = time[0].split("-")
            var timeSplt = time[1].split(":")

            dt2 = new Date("" + dateSplt[1] + "-" + dateSplt[0] + "-" + dateSplt[2] + ", " + timeSplt[0] + ":" + timeSplt[1] + ":" + timeSplt[2]); //audit start
            dt1 = new Date(Date.now());
            console.log(dt1);
            var hourDiff = diff_hours(dt1, dt2);
            console.log(diff_hours(dt1, dt2)); //here can validate if its under or over 24hrs already
            if (hourDiff >= 24) {
                $(".progress-bar").attr("style", "width:0%");
            } else {
                //var timesplt = time[1].split(":");
                //console.log(timesplt[1]);
                var now = new Date();
                var hrs = (24 - hourDiff);
                var mins = 59 - now.getMinutes();
                var secs = 59 - now.getSeconds();

                var totalMins = hrs * 60 + mins;
                var porcent = totalMins * 100 / 1440;
                $(".progress-bar").attr("style", "width:" + porcent + "%");
                document.getElementById('countdownToMidnight').innerHTML = '0 days, ' + hrs + ' hour' + (hrs == 1 ? ', ' : 's, ') + mins + ' minute' + (mins == 1 ? ', ' : 's, ') + secs + ' second' + (secs == 1 ? '. ' : 's.') + ' left.';
            }

        }
	</script>
</asp:Content>

