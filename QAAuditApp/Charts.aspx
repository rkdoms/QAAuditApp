﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Charts.aspx.cs" Inherits="QAAuditApp.Charts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
                <h2>QC GATE <b>Charts</b></h2>
                <br />
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="au-card-inner">
                                    <h3 class="title-2 m-b-40">Fails per Source</h3>
                                    <canvas id="pieChart"></canvas>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="au-card-inner">
                                    <h3 class="title-2 m-b-40">AVG Fails per Source</h3>
                                    <canvas id="avgFailsPerSource"></canvas>
                                </div>
                            </div>
                           
                            <div class="col-lg-3">
                                <h3 class="title-2 m-b-40">AVG Fails</h3>
                                <div class="statistic__item">
                                    <h2 class="number avgf">0</h2>
                                    <h3 class="title-2 m-b-20">Average Fails </h3>
                                    <div class="icon">
                                        <i class="zmdi zmdi-account-o"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
            <!-- END MAIN CONTENT-->
            <!-- Main JS-->
            <script src="Content/js/charts.js"></script>
</asp:Content>
