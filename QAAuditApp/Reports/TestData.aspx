<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="TestData.aspx.cs" Inherits="QAAuditApp.TestData" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<h2>QA Audit Detail Page:</h2>
<style>
    span.ob_gAL {
font-family: Verdana;
font-size: 10px;
color: #065a8e;
font-weight: normal;
text-decoration: none;
}
.ob_gRETpl legend {
    margin: 0 auto;
    text-align: center;
    border-bottom: 1px solid #ccc;
    }
div.buttons
{
    margin: 0 auto;
    text-align: center;
    border-top: 1px solid #ccc;
    padding: 5px 0 0 0;
    font-size:15px
}
#questions {
    list-style-type: decimal-leading-zero;
    }
#questions li{
    text-decoration:none;
    margin: 10px 40px;
    font-size:13px;
}
#questions input.data_notes{
    width:275px;
}
#questions label{ font-weight:100 !important;}
</style>

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
            <obout:Column HeaderText="Options" AllowEdit="true" AllowDelete="false" runat="server" TemplateId="EditBtnTemplate" EditTemplateId="updateBtnTemplate" />
		</Columns>
        <TemplateSettings RowEditTemplateId="IsActiveTmpl" />
		<Templates>
            <obout:GridTemplate runat="server" ID="EditBtnTemplate">
                <Template>
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
                    <form id="questionsForm">
                        <legend>Questions</legend>                        
                        <asp:TextBox ID="txt_jsonquestions" CssClass="data_jsonquestions" runat="server" style="display:none;"/>   
                        <asp:TextBox ID="txt_id" CssClass="data_id" runat="server" style="display:none;"/>     
                        <ul id="questions"></ul>
                        <div class="buttons">
                            <input type="button" value=" Send Information " onclick="ValidateQuestions()" class="tdText" />
                            <input type="button" value=" Cancel " onclick="grid1.cancel(); showAnswering()" class="tdText" /> 
                        </div>
                    </form>
                    </Template>
            </obout:GridTemplate>		
		</Templates>
	</obout:Grid>
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
                $("#questions li").each(function () {
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
    <li>
        <input type='hidden' value='__QUESTIONNUMBER__' class='data_qno'/>
        <div>__QUESTION__</div> 
        <div> 
            Notes: <input class='data_notes' name='notes__ID__' value='__NOTES__'/> 
            &nbsp; &nbsp;
            <input type='radio' id='r_ok__ID__' class='data_pass' name='rq__ID__' value='true' __CHECKEDTRUE__/>
            <label for='r_ok__ID__'>Pass </label> 
            <input type='radio' id='r_nok__ID__' name='rq__ID__' class='data_pass' value='false' __CHECKEDFALSE__/> 
            <label for='r_nok__ID__'>Fail  </label>

        </div>
    </li>
</script>
</asp:Content>
