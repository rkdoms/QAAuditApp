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
    <table>
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
            <td width="50%">
                <div>
                    Last Audit History:
                    <div style="font-size:12px;">
                        <asp:GridView ID="gv_lastest" runat="server" AutoGenerateColumns="False">
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
            <%--        <div>
                        Start Time : <asp:Label ID="lb_startdate" runat="server"></asp:Label>
                    </div>
                    <div>
                        End Time : <asp:Label ID="lb_endtime" runat="server"></asp:Label>
                    </div>
                    <div>
                        Created By : <asp:Label ID="lb_createdby" runat="server"></asp:Label>
                    </div>
                    <div>
                        QC Status  : <asp:Label ID="lb_status" runat="server"></asp:Label>
                    </div>--%>
                    <div style="text-align:right;">
                        <a href="#">See All</a>
                    </div>
                </div>
            </td>
        </tr>
    </table>

    <br />

    <div>
        <asp:Button ID="btn_start_audit" runat="server" Text="  Start Answering  " Visible="false" OnClick="btn_start_audit_Click" />
        <asp:Button ID="btn_end_audit" runat="server" Text="  Finish Answering  " style="display:none" OnClick="btn_end_audit_Click" />
    </div>

            <obout:Grid id="grid1" runat="server" CallbackMode="true" GroupBy="TestRecordId" HideColumnsWhenGrouping="true" ShowGroupFooter="false" ShowCollapsedGroups="true" Serialize="true" AllowGrouping="true" AllowPaging="false" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="false" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid" AllowRecordSelection="false" ShowFooter="false" Visible="false">
                <ClientSideEvents OnClientUpdate="Reload" />
			<Columns>
                <obout:Column DataField="SourceInfoId" ReadOnly="true" Visible="false" runat="server"/>	
                <obout:Column DataField="TestRecordId" ReadOnly="true" Visible="false" runat="server"/>	
                <obout:Column DataField="VerifiedBy" ReadOnly="true" HeaderText="Verified By" runat="server" AllowGroupBy="false" />								               
				<obout:Column DataField="VerifiedOn" ReadOnly="true" HeaderText="Verified On" runat="server" />
                <obout:Column DataField="QuestionNumber" HeaderText="Question Number" ReadOnly="true" runat="server"/>	
                <obout:Column DataField="Question" ReadOnly="true" runat="server"/>	
                <obout:CheckBoxColumn DataField="SourcePass" HeaderText="QA Status" Width="100" runat="server" TemplateId="IsActiveTmpl" />		
                <obout:Column DataField="Notes" HeaderText="Notes" runat="server"/>
				<obout:Column HeaderText="Options" Width="200" AllowEdit="true" AllowDelete="false" runat="server" />							
			</Columns>
			<Templates>	
                <obout:GridTemplate runat="server" ID="IsActiveTmpl">
                    <Template>
                        <%# (Container.Value.ToString() == "True" ? "Passed" : "Failed") %>               
                    </Template>
                </obout:GridTemplate>		
			</Templates>
		</obout:Grid>
    <script>
        function Reload(record) {
            //CODED BY FH
            var qaStatus = "<%=lb_passfail.Text%>"
                console.log(qaStatus)

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

            //CODED BY RM
            var flag = true;
            $(".ob_gBICont tbody tr").each(function () {
                //console.log($(this));
                //get all passFail QA Status
                var td = $(this).find("td").eq(5).find(".ob_gCd");
                //console.log(td.text());
                if (td.text() != "True") {
                    flag = false;
                    $("#<%= btn_end_audit.ClientID %>").hide();
                    $("#<%= lb_passfail.ClientID %>").text('Failed');
                    return false;
                }               
            });
            if (flag) {
                $("#<%= btn_end_audit.ClientID %>").show();
                $("#<%= lb_passfail.ClientID %>").text('Passed');
            }
            //console.log(record);
            //alert(document.location + 1);
            return true;
        }
        Reload(null);
    </script>
</asp:Content>
