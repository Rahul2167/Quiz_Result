<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Certificate</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <style>
            body {
                font-family: 'Segoe UI', Arial;
                background: #f0f2f5;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
            }

            #cert {
                width: 800px;
                padding: 40px;
                background: #fff;
                border: 10px solid #243b55;
                text-align: center;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            }

            .h {
                font-size: 40px;
                font-weight: bold;
                color: #243b55;
                margin-bottom: 30px;
            }

            .n {
                font-size: 32px;
                font-weight: bold;
                color: #d4af37;
                border-bottom: 2px solid #ddd;
                padding: 10px;
                margin: 20px 0;
            }

            .s {
                font-size: 24px;
                margin: 20px 0;
            }

            .p {
                color: green;
                font-weight: bold;
            }

            .f {
                color: red;
                font-weight: bold;
            }

            #dBtn {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: #243b55;
                color: white;
                border: none;
                padding: 15px;
                border-radius: 5px;
                cursor: pointer;
            }
        </style>
    </head>

    <body>
        <% String n=(String)session.getAttribute("f1"); if (n==null) n="Guest" ; String
            q1=(String)session.getAttribute("q1"); String q2=(String)session.getAttribute("q2"); String
            q3=(String)session.getAttribute("q3"); String q4=(String)session.getAttribute("q4"); String
            q5=(String)session.getAttribute("q5"); String q6=(String)session.getAttribute("q6"); String
            q7=(String)session.getAttribute("q7"); String q8=(String)session.getAttribute("q8"); String
            q9=(String)session.getAttribute("q9"); String q10=(String)session.getAttribute("q10"); int sc=0; if ("New
            Delhi".equals(q1)) sc++; if ("Mahatma Gandhi".equals(q2)) sc++; if ("Jupiter".equals(q3)) sc++; if
            ("Alexander" + " Graham " + "Bell" .equals(q4)) sc++; if ("Nile".equals(q5)) sc++; if ("2019".equals(q6))
            sc++; if ("Fiji".equals(q7)) sc++; String ans8="Department " + "of Research " + "and Development "
            + "Laboratory" ; if (ans8.equals(q8)) sc++; if ("Uranus".equals(q9)) sc++; if ("Dr A.P.J. " + " Abdul
            Kalam".equals(q10)) sc++; String rv=(sc>= 6) ? "PASS" : "FAIL";
            %>
            <div id="cert">
                <div class="h">Certificate of Completion</div>
                <p>This is to certify that</p>
                <div class="n">
                    <%= n %>
                </div>
                <p>has completed the General Knowledge Quiz.</p>
                <div class="s">Score: <b>
                        <%= sc %>/10
                    </b><br>Result: <span class="<%= rv.equals(" PASS")?"p":"f" %>"><%= rv %></span></div>
                <p>Generated on: <%= new java.util.Date() %>
                </p>
            </div>
            <button id="dBtn" onclick="h2p()">Download PDF</button>
            <script>
                function h2p() {
                    var e = document.getElementById('cert');
                    var o = { margin: 10, filename: 'Cert.pdf', image: { type: 'jpeg', quality: 0.98 }, html2canvas: { scale: 2 }, jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' } };
                    document.getElementById('dBtn').style.display = 'none';
                    html2pdf().set(o).from(e).save().then(function () { document.getElementById('dBtn').style.display = 'block'; });
                }
            </script>
    </body>

    </html>