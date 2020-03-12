<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QAAuditApp.History.Default" %>

<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>
.qa-team-notes tbody td {
    white-space: pre-line;
}
</style>
   <h2>QA Audit History Page:</h2>
    <br />
    <div class="row">
        <div class="col-6">
            <b>AUDIT HISTORY INFO</b>
            <br />
            <br />
            <table class="table table-borderless table-striped table-earning">
                <tr>
                    <td>
                        Source Info Id:<asp:DropDownList CssClass="form-control-lg form-control" ID="ddl_sourceinfoid" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddl_sourceinfoid_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                    <td>
                        Status : <asp:DropDownList Enabled="false" CssClass="form-control-lg form-control" ID="ddl_status" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddl_status_SelectedIndexChanged">
                                    <asp:ListItem Text="All Status" Value=""></asp:ListItem>
                                    <asp:ListItem Text="Passed" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Failed" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Incomplete" Value="2"></asp:ListItem>
                                 </asp:DropDownList>
                    </td>
                    <td>
                        Audits: <asp:DropDownList Enabled="false" ID="ddl_history" CssClass="form-control-lg form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_history_SelectedIndexChanged"></asp:DropDownList>
                    </td>
                </tr>
                <!--tr>
                    <td>
                        Date From:<asp:TextBox ID="txt_d_from" runat="server"></asp:TextBox>
                    </td>
                    <td>
                        Date To : <asp:TextBox ID="txt_d_to" runat="server"></asp:TextBox>
                    </td>
                </tr-->
            </table>
        </div>

    </div>
    <br />
 
    <asp:Panel ID="pnl_main" runat="server" Visible="false">
   
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
                        Created By : <asp:Label ID="lb_created" runat="server"></asp:Label>
                    </div>
                    <div>
                        QA Status : <asp:Label ID="lb_passfail" runat="server"></asp:Label>
                    </div>
                    <div>
                        Source Url: <asp:Label ID="lb_url" runat="server"></asp:Label>
                    </div>
                </td>
                </tr>
            </table>
        </div>
        <br />
    <b>TESTED RECORDS</b><br />

    <obout:Grid ID="grid1" runat="server" CallbackMode="true" Serialize="true" AllowPaging="false" RowEditTemplateId="IsActiveTmpl" AllowSorting="false" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="false"
        ShowFooter="false" Visible="false" EnableTypeValidation="false" AllowRecordSelection="false">
        <ClientSideEvents OnBeforeClientEdit="GetQuestions" />
        <Columns>
            <obout:Column DataField="IdMain" ReadOnly="true" Visible="false" runat="server" />
            <obout:Column DataField="Id" ReadOnly="true" Visible="false" runat="server" />
            <obout:Column DataField="Names" ReadOnly="true" HeaderText="Names" runat="server" Wrap="true" />
            <obout:Column DataField="DOB" ReadOnly="true" HeaderText="DOB" runat="server" />
            <obout:Column DataField="CaseNumber" HeaderText="Case Number" ReadOnly="true" runat="server" />
            <obout:Column DataField="CreatedOn" HeaderText="Created On" runat="server" />
            <obout:Column DataField="SourcePass" HeaderText="Status" runat="server" Width="80" TemplateId="IsPassTmpl" />
            <obout:Column DataField="Answered" runat="server" Width="100"/>
            <obout:Column DataField="DataScript" runat="server" Visible="false" >
                <TemplateSettings RowEditTemplateControlId="txt_data_script" RowEditTemplateControlPropertyName="value"  />
            </obout:Column>
             <%--<obout:Column DataField="SourceUrl" runat="server" Visible="false"  />--%>
            <obout:Column HeaderText="Options" Width="210" AllowEdit="true" AllowDelete="false" runat="server" TemplateId="EditBtnTemplate" EditTemplateId="updateBtnTemplate" />
        </Columns>
        <TemplateSettings RowEditTemplateId="IsActiveTmpl" />
        <Templates>
            <obout:GridTemplate runat="server" ID="IsPassTmpl">
                <Template>
                    <%# (Container.Value.ToString() == "True" ? "Passed" : "Failed") %>
                </Template>
            </obout:GridTemplate>
            <obout:GridTemplate runat="server" ID="EditBtnTemplate">
                <Template>
                <%--    <a href="#" onclick="javascript:setQueryText('Source Url','<%# Container.DataItem["SourceUrl"] %>');" data-dismiss="modal" data-backdrop="" data-toggle="modal" data-target="#preview-modal" class="ob_gAL" >Source Url</a>
                    |--%>
                   <input style="display:none" class="DataScriptQuery" value="<%# Container.DataItem["DataScript"] %>"/>
                    <a href="javascript: //" onclick="setQueryText(this);" class="ob_gAL" >Show Query</a>
                    |
                    <a class="ob_gAL answering" href="javascript: //" onclick="grid1.editRecord(this);hideAnswering();return false;">Show Questions</a>
                    <span class="ob_gAL answering" style="display: none">Show Questions</span>
                </Template>
            </obout:GridTemplate>
            <obout:GridTemplate runat="server" ID="updateBtnTemplate">
                <Template>
                    <a class="ob_gAL" href="javascript: //" onclick="grid1.cancel();showAnswering();return false;">Close</a>
                    |
                    <a href="javascript: //" onclick="setQueryText(this);" class="ob_gAL" >Show Query</a>
                    <asp:TextBox ID="txt_data_script" CssClass="DataScriptQuery" runat="server" style="display:none;"/>
                </Template>
            </obout:GridTemplate>
            <obout:GridTemplate runat="server" ID="IsActiveTmpl">
                <Template>
                    <div class="card">
                        <div class="card-header">
                            QUESTIONS
                        </div>
                        <div class="card-body card-block">
                            <asp:TextBox ID="txt_jsonquestions" CssClass="data_jsonquestions" runat="server" Style="                                    display: none;
                            " />
                            <asp:TextBox ID="txt_id" CssClass="data_id" runat="server" Style="display: none;" />
                            <ul id="questions"></ul>
                        </div>
                    </div>
                    </form>
                </Template>
            </obout:GridTemplate>
        </Templates>
    </obout:Grid>
    <asp:HiddenField ID="startTimeActive" runat="server" />
    <asp:HiddenField ID="endTimeActive" runat="server" />

    <b>QA TEAM NOTES</b><br />
    <table class="table table-borderless table-striped table-earning qa-team-notes">
        <tr>
            <td>
                <asp:Label ID="lb_qa_team_notes" runat="server"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Panel>
<script>    

    function setQueryText(id) {
        var element = $(id).parent().find(".DataScriptQuery");
        console.log(element);
        Swal.fire(
            'Database Query',
            element.val(),
            'info'
        );
    }

    //load questios from ajax/questions
    function GetQuestions(record) {
        console.log(record);
            
        $("#questions").html("loading...");
        $.get("/Ajax/HistoryQuestions?idmain=" + record.IdMain +"&idtestdata=" + record.Id, function (data) {
            json = JSON.parse(data)
            var liTmpl = $("#liTemplate").html();

            var li = "";
            $(json).each(function () {                    
                var q = $(this)[0]; 
                var row = liTmpl.replace(/__QUESTION__/g, q.Question);
                row = row.replace(/__NOTES__/g, q.Notes);
                row = row.replace(/__VERIFIEDBY__/g, q.VerifiedBy);
                row = row.replace(/__VERIFIEDON__/g, q.VerifiedOn);
                if (q.SourcePass) 
                    row = row.replace(/__STATUS__/g, 'Passed');
                else 
                    row = row.replace(/__STATUS__/g, 'Failed');
                li += row;
            });
            if (li == "")  li = "this record has no questions";          
            $("#questions").html(li);
        });
            
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
            <label style='white-space: pre-wrap; color: #2b4c61;' for='cc-payment' class='control-label mb-1'>__QUESTION__ (__STATUS__)</label><br />
            Notes: __NOTES__ 
            <br />
            Verified By: __VERIFIEDBY__<br />
            Verified On: __VERIFIEDON__<br />
            <hr>
        </div>
    </script>
</asp:Content>
