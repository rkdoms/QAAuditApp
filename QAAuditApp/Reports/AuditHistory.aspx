<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuditHistory.aspx.cs" Inherits="QAAuditApp.AuditHistory" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>QA Audit History Page:</h2>
<style>
span.ob_gAL {
    font-family: Verdana;
    font-size: 10px;
    color: #065a8e;
    font-weight: normal;
    text-decoration: none;
}
    #MainContent_gv_lastest span > tr {
    background-color:yellow;
    }
</style>
<br />
    <div class="row">
        <div class="col-6">
             <b>AUDIT HISTORY INFO</b>
            <br />
            <br />
            <table class="table table-borderless table-striped table-earning">
                <tr>
                <td width="50%">
                    <cbo:OboutDropDownList ID="ddl_history" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddl_history_SelectedIndexChanged"></cbo:OboutDropDownList>
                </td>
                </tr>
            </table>
        </div>

    </div>
   

    <br />

<b>TEST RECORDS</b><br />

<obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AllowSorting="false" AllowPaging="false" RowEditTemplateId="IsActiveTmpl" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="false" 
    OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid" ShowFooter="false" Visible="false" EnableTypeValidation="false" AllowRecordSelection="false">
    <ClientSideEvents OnBeforeClientEdit="GetQuestions" OnClientUpdate="Reload" />
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
    <%-- <obout:Column DataField="Origin" ReadOnly="true" runat="server"/>--%>	
    <obout:Column DataField="CreatedOn" HeaderText="Created On" runat="server"/>  
    <obout:Column DataField="SourcePass" HeaderText="Status" runat="server" Width="80" TemplateId="IsPassTmpl" /> 
    <obout:Column DataField="DataScript" runat="server" Visible="false"  /> 
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
            <a class="ob_gAL" href="javascript:alert('<%# Container.DataItem["DataScript"] %>');" >Show Query</a>
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
                    <input type="button" value=" Save " onclick="ValidateQuestions()" class="btn btn-success btn-lg btn-save" />
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
            if (li == "") {
                li = "this record has no questions";
                $(".btn.btn-success.btn-lg.btn-save").hide();
            } else $(".btn.btn-success.btn-lg.btn-save").show();
            $("#questions").html(li);
        });
            
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
