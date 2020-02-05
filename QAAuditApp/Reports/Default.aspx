<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QAAuditApp.Reports_Default" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    QA Audit Interface:
    <br /><br />
            <obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="true" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid" AllowRecordSelection="false" PageSize="50">
			<Columns>
				<obout:Column DataField="SourceInfoId" ReadOnly="true" HeaderText="Source id" Visible="false" runat="server"/>	
                <obout:Column DataField="PendingAudit" ReadOnly="true" HeaderText="PendingAudit" Visible="false" runat="server"/>	
                <obout:Column DataField="SourceType" HeaderText="Source Type" runat="server" ReadOnly="true" Width="105"/>
				<obout:Column DataField="SourceName" ReadOnly="true" HeaderText="Source Name" runat="server" TemplateId="LinkDetailTmpl"/>								
                <obout:CheckBoxColumn DataField="SourcePass" HeaderText="Status" Width="75" ReadOnly="true" runat="server" TemplateId="IsActiveTmpl" />
                <obout:Column DataField="TimesAudited" ReadOnly="true" HeaderText="Audited" runat="server" Width="120" TemplateId="TimesAuditedTmpl"  />
				<obout:Column DataField="LastAudited" ReadOnly="true" HeaderText="Last Audited" runat="server"  Width="140" TemplateId="LastAuditedTmpl" />
				<obout:Column DataField="PriorityName" HeaderText="Priority" runat="server" EditTemplateId="updatePriorityTemplate"/>                
                <obout:Column DataField="SourcePoints" HeaderText="Points" runat="server"  Width="80"/>     
                <obout:CheckBoxColumn DataField="SourceIsActive" HeaderText="Is Active" Width="100" runat="server" />
				<obout:Column HeaderText="Options" Width="100" AllowEdit="true" AllowDelete="false" runat="server" />							
			</Columns>
			<Templates>	
                <obout:GridTemplate runat="server" ID="LinkDetailTmpl">
                    <Template>
                        <a href="Details?sourceinfoID=<%# Container.DataItem["SourceInfoId"] %>"><%# Container.DataItem["SourceInfoId"] %> - <%# Container.DataItem["SourceName"] %></a>  <%# (Container.DataItem["PendingAudit"].ToString() == "1" ? "(Pending Audit)" : "") %>                     
                    </Template>
                </obout:GridTemplate>
                <obout:GridTemplate runat="server" ID="IsActiveTmpl">
                    <Template>
                        <%# (Container.Value.ToString() == "True" ? "Passed" : "Failed") %>               
                    </Template>
                </obout:GridTemplate>
                <obout:GridTemplate runat="server" ID="TimesAuditedTmpl">
                    <Template>
                        <%# Container.Value.ToString() %> Times               
                    </Template>
                </obout:GridTemplate>
                <obout:GridTemplate runat="server" ID="LastAuditedTmpl">
                    <Template>
                        <%# (Convert.ToDateTime(Container.Value.ToString()) == DateTime.MinValue ? "Not Set" : Container.Value.ToString()) %>               
                    </Template>
                </obout:GridTemplate>
                <obout:GridTemplate runat="server" ID="updatePriorityTemplate" ControlID="ob_iDdlPriorityTB" ControlPropertyName="value">
               <Template>
                   <cbo:OboutDropDownList ID="Priority" runat="server" OnLoad="Priority_Load">                       
                   </cbo:OboutDropDownList> 
               </Template>
                </obout:GridTemplate>			
			</Templates>
		</obout:Grid>
</asp:Content>
