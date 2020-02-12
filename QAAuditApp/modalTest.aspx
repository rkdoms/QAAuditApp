<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="modalTest.aspx.cs" Inherits="QAAuditApp.modalTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Content/sweetalert2.min.js"></script>
    <link rel="stylesheet" href="/Content/sweetalert2.min.css">
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <input type="button" value="alert test" onclick="callSweetMsg()" class="btn btn-success btn-lg" />
        </div>
    </form>
</body>
</html>
<script>    
    function callSweetMsg() {
        //import swal from '../Content/sweetalert2/dist/sweetalert2.js'
        //import 'sweetalert2/src/sweetalert2.scss'

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.value) {
                Swal.fire(
                    'Deleted!',
                    'Your file has been deleted.',
                    'success'
                )
            }
        })
    }
</script>