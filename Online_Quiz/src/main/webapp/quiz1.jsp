<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quiz 1</title>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz 1</title>

    <style>
    #welcome{
   			 display: flex;
            justify-content: flex-start;
            text-align:centre;
            margin-top: 20px;
            color: #333;
   			 }
    #timer{
    		display: flex;
            justify-content: center;
            text-align:centre;
      }
         body {
            height: 100vh;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: Arial, Helvetica, sans-serif;
        }

        .quiz-box {
            background: #fff;
            padding: 35px;
            width: 420px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .option {
            display: flex;
            align-items: center;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: 0.3s;
        }

        .option:hover {
            background: #f0f4ff;
        }

        .option input {
            margin-right: 12px;
            cursor: pointer;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
        }

        button:hover {
            background: #5a67d8;
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
        let selected = document.querySelector("input[name='q1']:checked");

        if (!selected) return false;

        let correctAnswer = "New Delhi";
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

      <h1 id=welcome>Welcome, <% String f1= request.getParameter("fullname"); %>!</h1>
      <%
      String q1 = request.getParameter("q1");
      session.setAttribute("q1", q1);
      session.setAttribute("f1", f1);
  %>
    
    <form class="quiz-box" action="quiz2.jsp" method="post" onsubmit="return checkAnswer()">
    <div id="timer" style="color:red;font-weight:bold"></div>

        <h2>1️) What is the capital of India?</h2>

        <label class="option">
            <input type="radio" name="q1" value="Mumbai" required>
            A) Mumbai
        </label>

        <label class="option">
            <input type="radio" name="q1" value="New Delhi">
            B) New Delhi
        </label>

        <label class="option">
            <input type="radio" name="q1" value="Kolkata">
            C) Kolkata
        </label>

        <label class="option">
            <input type="radio" name="q1" value="Chennai">
            D) Chennai
        </label>

        <button type="submit">Submit & Next</button>
        

    </form>

</body>
</html>



