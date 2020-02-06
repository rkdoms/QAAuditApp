<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default2.aspx.cs" Inherits="QAAuditApp.Reports_Default2" %>
<%@ Register TagPrefix="obout" Namespace="Obout.Grid" Assembly="obout_Grid_NET" %>
<%@ Register TagPrefix="cbo" Namespace="Obout.Interface" Assembly="obout_Interface" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    QA Audit Interface:
    <br /><br />
        <div class="ob_gHICont">
            <asp:GridView ID="gv" runat="server">

            </asp:GridView>
        </div>  
</asp:Content>
