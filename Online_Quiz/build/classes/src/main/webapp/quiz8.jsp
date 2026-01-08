<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz 8</title>

    <style>
    #timer{
    		display: flex;
            justify-content: center;
            text-align:centre;
      }
        body {
            height: 100vh;
            background: linear-gradient(135deg, #2193b0, #6dd5ed);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, Helvetica, sans-serif;
        }

        .quiz-box {
            background: white;
            padding: 35px;
            width: 420px;
            border-radius: 12px;
            box-shadow: 0 12px 28px rgba(0,0,0,0.25);
        }

        h2 {
            margin-bottom: 22px;
            color: #222;
        }

        .option {
            display: flex;
            align-items: center;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: 0.3s;
        }

        .option:hover {
            background: #eefaff;
        }

        .option input {
            margin-right: 12px;
            cursor: pointer;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #2193b0;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
        }

        button:hover {
            background: #1c7e97;
        }
        	.correct {
		    animation: blinkGreen 1s 3;
		    border: 2px solid green !important;
		}
		
		.wrong {
		    animation: blinkRed 1s 3;
		    border: 2px solid red !important;
		}
		
		@keyframes blinkGreen {
		    0% { background: #d4edda; }
		    50% { background: white; }
		    100% { background: #d4edda; }
		}
		
		@keyframes blinkRed {
		    0% { background: #f8d7da; }
		    50% { background: white; }
		    100% { background: #f8d7da; }
		}
    </style>
    <script>
    let time = 15; // seconds

    setInterval(() => {
        if (time <= 0) {
            document.forms[0].submit();
        }
        document.getElementById("timer").innerHTML = time + " sec";
        time--;
    }, 1000);
    function checkAnswer() {
        let options = document.querySelectorAll(".option");
        let selected = document.querySelector("input[name='q8']:checked");

        if (!selected) return false;

        let correctAnswer = "Department of Research and Development Laboratory";
        let parentLabel = selected.closest(".option");

        if (selected.value === correctAnswer) {
            parentLabel.classList.add("correct");
        } else {
            parentLabel.classList.add("wrong");
        }

        // Stop immediate submit, allow blink first
        setTimeout(() => {
            document.forms[0].submit();
        }, 1500);

        return false;
    }
</script>
</head>
<body>
<%
    session.setAttribute("q7", request.getParameter("q7"));
%>

    <form class="quiz-box" action="quiz9.jsp" method="post" onsubmit="return checkAnswer()">
        <div id="timer" style="color:red;font-weight:bold"></div>

        <h2>8) What is the full form of DRDL?</h2>

        <label class="option">
            <input type="radio" name="q8" value="Differential Research and Documentation Laboratory" required>
            A) Differential Research and Documentation Laboratory
        </label>

        <label class="option">
            <input type="radio" name="q8" value="Department of Research and Development Laboratory">
            B) Department of Research and Development Laboratory
        </label>

        <label class="option">
            <input type="radio" name="q8" value="Defense Research and Development Laboratory">
            C) Defense Research and Development Laboratory
        </label>

        <label class="option">
            <input type="radio" name="q8" value="None of the above">
            D) None of the above
        </label>

        <button type="submit">Finish Quiz</button>

    </form>

</body>
</html>
