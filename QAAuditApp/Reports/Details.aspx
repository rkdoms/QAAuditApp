<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="QAAuditApp.Details" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>QA Audit Detail Page:</h2>
    <br />
        <div class="progress">
            <div class="progress-bar" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                
            </div>
             
        </div>
        <b><div id="countdown"></div></b><br />
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

            <obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AllowPaging="false" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="false" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid" AllowRecordSelection="false" ShowFooter="false" Visible="false">
                <ClientSideEvents OnClientUpdate="Reload" />
			<Columns>
                <obout:Column DataField="SourceInfoId" ReadOnly="true" Visible="false" runat="server"/>	                
                <obout:Column DataField="VerifiedBy" ReadOnly="true" HeaderText="Verified By" runat="server" />								               
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
        <asp:HiddenField id="startTimeActive" runat="server"/>
         <asp:HiddenField id="endTimeActive" runat="server"/>
    
    <script>

        function countdownTimer() {
            try {
                var endTime = "<%=endTimeActive.Value%>";
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
            }catch (err) {
                console.log('error ->'+err)
            }

        }

        countdownTimer();
        setInterval(countdownTimer, 1000);



        function Reload() {
            window.setInterval(function () {
                //ShowTimes();
            }, 1000);
        }

        
    </script>
</asp:Content>
