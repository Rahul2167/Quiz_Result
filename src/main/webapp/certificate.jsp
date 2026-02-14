<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Certificate of Completion</title>
        <!-- Import html2pdf library -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f0f2f5;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
            }

            #certificate {
                width: 800px;
                padding: 40px;
                background: #fff;
                border: 10px solid #243b55;
                text-align: center;
                position: relative;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            }

            .header {
                font-size: 40px;
                font-weight: bold;
                color: #243b55;
                margin-bottom: 10px;
                text-transform: uppercase;
                letter-spacing: 2px;
            }

            .sub-header {
                font-size: 20px;
                color: #555;
                margin-bottom: 30px;
            }

            .name {
                font-size: 32px;
                font-weight: bold;
                color: #d4af37;
                /* Gold color */
                border-bottom: 2px solid #ddd;
                display: inline-block;
                padding-bottom: 5px;
                margin: 10px 0 30px 0;
            }

            .score-section {
                font-size: 24px;
                margin: 20px 0;
                color: #333;
            }

            .pass {
                color: green;
                font-weight: bold;
            }

            .fail {
                color: red;
                font-weight: bold;
            }

            table {
                width: 90%;
                margin: 20px auto;
                border-collapse: collapse;
                font-size: 14px;
                text-align: left;
            }

            th,
            td {
                padding: 8px 12px;
                border-bottom: 1px solid #ddd;
            }

            th {
                background-color: #f8f9fa;
                color: #243b55;
            }

            .footer {
                margin-top: 40px;
                font-size: 12px;
                color: #777;
            }

            #downloadBtn {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: #243b55;
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            #downloadBtn:hover {
                background: #1a2b3c;
            }

            /* Print styles to hide button */
            @media print {
                #downloadBtn {
                    display: none;
                }
            }
        </style>
    </head>

    <body>

        <% /* Retrieve Name */ String name=(String) session.getAttribute("f1"); if(name==null) name="Guest Candidate" ;
            /* Retrieve Answers */ String q1=(String) session.getAttribute("q1"); String q2=(String)
            session.getAttribute("q2"); String q3=(String) session.getAttribute("q3"); String q4=(String)
            session.getAttribute("q4"); String q5=(String) session.getAttribute("q5"); String q6=(String)
            session.getAttribute("q6"); String q7=(String) session.getAttribute("q7"); String q8=(String)
            session.getAttribute("q8"); String q9=(String) session.getAttribute("q9"); String q10=(String)
            session.getAttribute("q10"); /* Recalculate Score */ int score=0; if ("New Delhi".equals(q1)) score++; if
            ("Mahatma Gandhi".equals(q2)) score++; if ("Jupiter".equals(q3)) score++; if ("Alexander Graham
            Bell".equals(q4)) score++; if ("Nile".equals(q5)) score++; if ("2019".equals(q6)) score++; if
            ("Fiji".equals(q7)) score++; if ("Department of Research and Development Laboratory".equals(q8)) score++; if
            ("Uranus".equals(q9)) score++; if ("Dr A.P.J. Abdul Kalam".equals(q10)) score++; String result=(score>= 6) ?
            "PASS" : "FAIL";
            String resultClass = (score >= 6) ? "pass" : "fail";
            %>

            <!-- PDF Content Container -->
            <div id="certificate">
                <div class="header">Certificate of Completion</div>
                <div class="sub-header">Online General Knowledge Quiz</div>

                <p>This is to certify that</p>
                <div class="name">
                    <%= name %>
                </div>
                <p>has completed the online quiz assessment.</p>

                <div class="score-section">
                    Score: <b>
                        <%= score %>/10
                    </b> <br>
                    Result: <span class="<%= resultClass %>">
                        <%= result %>
                    </span>
                </div>

                <h3>Candidate Response Sheet</h3>
                <table>
                    <tr>
                        <th>#</th>
                        <th>Question Keyword</th>
                        <th>Correct Answer</th>
                        <th>Your Answer</th>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>Capital of India</td>
                        <td>New Delhi</td>
                        <td>
                            <%= q1 %>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>Father of Nation</td>
                        <td>Mahatma Gandhi</td>
                        <td>
                            <%= q2 %>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>Largest Planet</td>
                        <td>Jupiter</td>
                        <td>
                            <%= q3 %>
                        </td>
                    </tr>
                    <tr>
                        <td>4</td>
                        <td>Telephone Inventor</td>
                        <td>Alexander Graham Bell</td>
                        <td>
                            <%= q4 %>
                        </td>
                    </tr>
                    <tr>
                        <td>5</td>
                        <td>Longest River</td>
                        <td>Nile</td>
                        <td>
                            <%= q5 %>
                        </td>
                    </tr>
                    <tr>
                        <td>6</td>
                        <td>Covid Start Year</td>
                        <td>2019</td>
                        <td>
                            <%= q6 %>
                        </td>
                    </tr>
                    <tr>
                        <td>7</td>
                        <td>Country</td>
                        <td>Fiji</td>
                        <td>
                            <%= q7 %>
                        </td>
                    </tr>
                    <tr>
                        <td>8</td>
                        <td>DRDL Full Form</td>
                        <td>Dept. of Research...</td>
                        <td>
                            <%= q8 %>
                        </td>
                    </tr>
                    <tr>
                        <td>9</td>
                        <td>Planet</td>
                        <td>Uranus</td>
                        <td>
                            <%= q9 %>
                        </td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>Missile Man</td>
                        <td>Dr A.P.J. Abdul Kalam</td>
                        <td>
                            <%= q10 %>
                        </td>
                    </tr>
                </table>

                <div class="footer">
                    Generated on: <%= new java.util.Date() %> <br>
                        Online Quiz Portal
                </div>
            </div>

            <button id="downloadBtn" onclick="downloadPDF()">Download PDF</button>

            <script>
                function downloadPDF() {
                    const element = document.getElementById('certificate');
                    const opt = {
                        margin: 10,
                        filename: 'Certificate_<%= name %>.pdf',
                        image: { type: 'jpeg', quality: 0.98 },
                        html2canvas: { scale: 2 },
                        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
                    };

                    // Old button hide
                    document.getElementById('downloadBtn').style.display = 'none';

                    // Generate PDF
                    html2pdf().set(opt).from(element).from(element).save().then(function () {
                        // Show button again
                        document.getElementById('downloadBtn').style.display = 'block';
                    });
                }
            </script>

    </body>

    </html>