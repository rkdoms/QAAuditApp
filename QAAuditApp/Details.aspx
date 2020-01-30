<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="QAAuditApp.Details" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    QA Audit Interface:
    <br /><br />
            <obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="true" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid">
			<Columns>
                <obout:Column DataField="id" ReadOnly="true" Visible="false" runat="server"/>	
                <obout:Column DataField="Sourceinfoid" ReadOnly="true" HeaderText="Source id" Width="100" runat="server"/>	
                <obout:Column DataField="VerifiedBy" ReadOnly="true" HeaderText="Verified By" runat="server" />								               
				<obout:Column DataField="VerifiedOn" ReadOnly="true" HeaderText="Verified On" runat="server" />
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
</asp:Content>
