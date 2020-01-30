<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QAAuditApp._Default" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    QA Audit Interface:
    <br /><br />
            <obout:Grid id="grid1" runat="server" CallbackMode="true" Serialize="true" AutoGenerateColumns="false" AllowAddingRecords="false" AllowFiltering="true" 
                OnUpdateCommand="grid1_UpdateCommand" OnRebind="RebindGrid">
			<Columns>
				<obout:Column DataField="Sourceinfoid" ReadOnly="true" HeaderText="Source id" Width="100" runat="server"/>	
                <obout:Column DataField="SourceType" HeaderText="Source Type" runat="server" ReadOnly="true"/>
				<obout:Column DataField="Source" ReadOnly="true" HeaderText="Source" runat="server" TemplateId="LinkDetailTmpl"/>								
                <obout:CheckBoxColumn DataField="PassFail" HeaderText="Pass/Fail" Width="100" ReadOnly="true" runat="server" TemplateId="IsActiveTmpl" />
				<obout:Column DataField="Last_Audited" ReadOnly="true" HeaderText="Last Audited" runat="server" />
				<obout:Column DataField="Name" HeaderText="Priority" runat="server" EditTemplateId="updatePriorityTemplate"/>
                <obout:Column DataField="Points" HeaderText="Points" runat="server" />     
                <obout:CheckBoxColumn DataField="SourceIsActive" HeaderText="Is Active" Width="100" runat="server" TemplateId="IsActiveTmpl" />
				<obout:Column HeaderText="Options" Width="200" AllowEdit="true" AllowDelete="false" runat="server" />							
			</Columns>
			<Templates>	
                <obout:GridTemplate runat="server" ID="LinkDetailTmpl">
                    <Template>
                        <a href="Details?sourceinfoID=<%# Container.DataItem["Sourceinfoid"] %>"><%# Container.DataItem["Source"] %></a>                        
                    </Template>
                </obout:GridTemplate>
                <obout:GridTemplate runat="server" ID="IsActiveTmpl">
                    <Template>
                        <%# Container.Value.ToString() %>               
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
    <!--
        <asp:ListItem Text="High" Value="3"></asp:ListItem>
                       <asp:ListItem Text="Normal" Value="2"></asp:ListItem>
                       <asp:ListItem Text="Low" Value="1"></asp:ListItem>
        -->
</asp:Content>
