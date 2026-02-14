<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz 9</title>

    <style>
    #timer{
    		display: flex;
            justify-content: center;
            text-align:centre;
      }
        body {
            height: 100vh;
            background: linear-gradient(135deg, #56ab2f, #a8e063);
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
            background: #f3ffe9;
        }

        .option input {
            margin-right: 12px;
            cursor: pointer;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #56ab2f;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
        }

        button:hover {
            background: #4b9a28;
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
    let time = 15 // seconds

    setInterval(() => {
        if (time <= 0) {
            document.forms[0].submit();
        }
        document.getElementById("timer").innerHTML = time + " sec";
        time--;
    }, 1000);
    function checkAnswer() {
        let options = document.querySelectorAll(".option");
        let selected = document.querySelector("input[name='q9']:checked");

        if (!selected) return false;

        let correctAnswer = "Uranus";
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
    session.setAttribute("q8", request.getParameter("q8"));
%>

    <form class="quiz-box" action="quiz10.jsp" method="post" onsubmit="return checkAnswer()">
        <div id="timer" style="color:red;font-weight:bold"></div>

        <h2>9) The green planet in the solar system is?</h2>

        <label class="option">
            <input type="radio" name="q9" value="Mars" required>
            A) Mars
        </label>

        <label class="option">
            <input type="radio" name="q9" value="Uranus">
            B) Uranus
        </label>

        <label class="option">
            <input type="radio" name="q9" value="Venus">
            C) Venus
        </label>

        <label class="option">
            <input type="radio" name="q9" value="Earth">
            D) Earth
        </label>

        <button type="submit">Finish Quiz</button>

    </form>

</body>
</html>
