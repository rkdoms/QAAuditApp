<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="TestData.aspx.cs" Inherits="QAAuditApp.TestData" %>
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
    <div class="row">
        <div class="col-6">
            <b>Last Audit History</b> <button class="btn btn-primary btn-sm">SEE ALL</button>
            <br />
            <br />
            <div style="font-size:10px;">
                <asp:GridView ID="gv_lastest" runat="server" AutoGenerateColumns="False" CssClass="table table-borderless table-striped table-earning">
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
            </table>
        </div>

    </div>
   

    <br />

    <div>
        <asp:Button ID="btn_start_audit" runat="server" Text="  Start Answering  " Visible="false" OnClick="btn_start_audit_Click" />
        <asp:Button ID="btn_end_audit" runat="server" Text="  Finish Answering  " style="display:none" OnClick="btn_end_audit_Click" />
    </div>
    <script type="text/javascript">
        function setRecordEvents(record) {
            console.log(record);
            //grid1.editRecord(record[0].Index);
            for (var i = 0; i < grid1.Rows.length; i++) {
                if (grid1.Rows[i] && grid1.Rows[i].Cells) {
                    if (grid1.Rows[i].Cells['Id'].Value == record[0].Id) {
                        grid1.editRecord(i);
                        return;
                    }
                }
            }
            //grid1.editRecord(0);
            //var sRecordIds = grid1.SelectedRecords
        }
		</script>
            <obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AllowSorting="false" AllowPaging="false" RowEditTemplateId="IsActiveTmpl" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="false" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid" ShowFooter="false" Visible="false" EnableTypeValidation="false" AllowRecordSelection="false">
                <ClientSideEvents OnBeforeClientEdit="GetQuestions" />
			<Columns>
                <obout:Column DataField="Id" ReadOnly="true" Visible="false" runat="server"/>		 
                <obout:Column DataField="SourceInfoId" ReadOnly="true" Visible="false" runat="server"/>
                <obout:Column DataField="QuestionJson" Visible="false" runat="server">
                    <TemplateSettings RowEditTemplateControlId="hdf_jsonquestions" RowEditTemplateControlPropertyName="value"  />
                </obout:Column>	
                <obout:Column DataField="Names" ReadOnly="true" HeaderText="Names" runat="server" />								               
				<obout:Column DataField="DOB" ReadOnly="true" HeaderText="DOB" runat="server" />
                <obout:Column DataField="CaseNumber" HeaderText="Case Number" ReadOnly="true" runat="server"/>	
                <obout:Column DataField="Origin" ReadOnly="true" runat="server"/>	
                <obout:Column DataField="CreatedOn" HeaderText="QA Status" Width="100" runat="server"/>       
                <obout:Column HeaderText="Options" Width="100" AllowEdit="true" AllowDelete="false" runat="server" EditTemplateId="updateBtnTemplate" />
			</Columns>
            <TemplateSettings RowEditTemplateId="IsActiveTmpl" />
			<Templates>
                <obout:GridTemplate runat="server" ID="updateBtnTemplate">
                    <Template>
                        <b>Editing...</b>
                    </Template>
                </obout:GridTemplate>
                <obout:GridTemplate runat="server" ID="IsActiveTmpl">
                    <Template>
                        <form id="questionsForm">
                            <div class="card">
                                    <div class="card-header">
                                       QUESTIONS
                                    </div>
                                    <div class="card-body card-block">
                                        <asp:HiddenField ID="hdf_jsonquestions" runat="server" />                     
                                        <ul id="questions"></ul>
                            
                                        <div class="form-actions form-group pull-right">
                                            <button type="submit" onclick="ValidateQuestions()" class="btn btn-success btn-lg">SAVE</button>
                                            <button type="submit" onclick="grid1.cancel()" class="btn btn-warning btn-lg">CANCEL</button>
                                        </div>
                                    </div>
                                </div>
                            
                        </form>
                     </Template>
                </obout:GridTemplate>		
			</Templates>
		</obout:Grid>
    
    <script>

        function ValidateQuestions() {
            if (confirm("OK?") === true) {
                $("#MainContent_grid1_IsActiveTmpl_ctl00_hdf_jsonquestions").val('[{"Id":1,"Notes":"notes wt","SourcePass":true}]');
                grid1.save();
            }else alert('cancel btn');
        }

        function GetQuestions(record) {
            console.log(record);
            //$(".btn_load_questions").click();
            $.get("../Ajax/Questions?id=" + record.Id, function (data) {
                json = JSON.parse(data)
                console.log(json);
                //var liTmpl = "<li><div>__QUESTION__</div><br><div> Notes: <input name='notes__ID__' value='__NOTES__'/> </div><div><input type='radio' id='r_ok__ID__' name='rq__ID__' value='Passed'/><label for='r_ok__ID__'>Passed </label> <br> <input type='radio' id='r_nok__ID__' name='rq__ID__' value='Failed'/> <label for='r_nok__ID__'>Failed  </label></div></li>";
                //var liTmpl = "<ul class='list-group list-group-horizontal'><li class='list-group-item'>Cras justo odio</li><li class='list-group-item'>Dapibus ac facilisis in</li><li class='list-group-item'>Morbi leo risus</li></ul>";
                //var liTmpl = "<div class='container-fluid'><div class='row'><div class='col-lg-12'><div class='table-responsive table--no-card m-b-30'><table class='table table-borderless table-striped table-earning'><tbody><tr><td><b>__QUESTION__</b></td><td><b>NOTES: </b> <input style='border: 1px solid silver;width: 100%;height:24px;padding: 7px;' name='notes__ID__' value='__NOTES__'/></td><td class='text-right'><input type='radio' id='r_ok__ID__' name='rq__ID__' value='Passed'/><label for='r_ok__ID__'>Passed </label>&nbsp<input type='radio' id='r_nok__ID__' name='rq__ID__' value='Failed'/> <label for='r_nok__ID__'>Failed  </label></td></tr></table></div></div></div></div>";
                var liTmpl = "<label style='white-space: pre-wrap;color:#2b4c61;' for='cc-payment' class='control-label mb-1' >__QUESTION__</label ><input id='notes__ID__' name='notes__ID__' type='text' class='form-control' aria-required='true' aria-invalid='false' value='__NOTES__' placeholder='NOTES'><input type='radio' id='r_ok__ID__' name='rq__ID__' value='Passed'/><label for='r_ok__ID__'>Passed </label>&nbsp<input type='radio' id='r_nok__ID__' name='rq__ID__' value='Failed'/> <label for='r_nok__ID__'>Failed  </label><hr>"
                    var li = "";
                $(json.AuditQuestion).each(function () {                    
                    var question = $(this); 
                    var row = liTmpl.replace(/__QUESTION__/g, $(this)[0].Question);
                    row = row.replace(/__ID__/g, $(this)[0].Id);
                    row = row.replace(/__NOTES__/g, $(this)[0].Notes);
                    //console.log(question[0].Question);
                    li += row;
                    //li += "<li>" + $(this)[0].Question + "</br> Notes: <input name='notes" + $(this)[0].Id +"' value='" + $(this)[0].Notes + "'/> <input type='checkbox' name='q" + $(this)[0].Id  +"'> Pass?</li>";
                });
                $("#questions").html(li);
            });
            
        }

        function Reload(record) {
            console.log(record);
        }

    </script>

</asp:Content>
