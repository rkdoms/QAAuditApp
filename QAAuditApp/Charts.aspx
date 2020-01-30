<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Charts.aspx.cs" Inherits="QAAuditApp.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <h2>QC GATE <b>Charts</b></h2>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="au-card-inner">
                                    <h3 class="title-2 m-b-40">Fails per Source</h3>
                                    <canvas id="pieChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            
            <!-- END MAIN CONTENT-->
            <!-- Main JS-->
            <script src="Content/js/charts.js"></script>
</asp:Content>
