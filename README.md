click to check the website :--  https://online-quiz-i2p3.onrender.com

<img width="1916" height="1015" alt="image" src="https://github.com/user-attachments/assets/a0dc1bfb-1b36-4c6c-8f14-99c279310522" />
<img width="1897" height="1017" alt="image" src="https://github.com/user-attachments/assets/252ce3db-f80d-437e-a368-379503477965" />
<img width="1892" height="1011" alt="image" src="https://github.com/user-attachments/assets/f0003962-3b67-4b9c-8df9-02291fb34b7e" />
<img width="1895" height="1010" alt="image" src="https://github.com/user-attachments/assets/77104327-e51e-45d4-b390-a9d6f8d311ac" />
<img width="1899" height="1014" alt="image" src="https://github.com/user-attachments/assets/3ccd1b4b-53ef-4e2a-b7d3-c821cc36f603" />
<img width="1911" height="1022" alt="image" src="https://github.com/user-attachments/assets/c879a03a-8edd-44c9-a347-ddbe4e7bfe28" />
<img width="1900" height="1020" alt="image" src="https://github.com/user-attachments/assets/478ccb01-ab12-4f8e-ba08-3759e96ce36c" />

# Online Quiz Application (JSP)

## Table of Contents
- [Online Quiz Application (JSP)](#online-quiz-application-jsp)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [How to Use](#how-to-use)
- [Known Issues / Limitations](#known-issues--limitations)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## Features

- **10 Quiz Questions** – General knowledge topics with four options each.
- **Timed Questions** – 15 seconds per question; auto‑submits if time runs out.
- **Instant Feedback** – Selected answer blinks green (correct) or red (wrong) before proceeding.
- **Session Management** – All answers are stored in `HttpSession` and evaluated at the end.
- **Score & Result** – Final score (Pass if ≥6 correct) displayed with a detailed answer review.
- **Leaderboard** – Rankings based on score (highest first) with date stamps.
- **Certificate Placeholder** – Attempts to generate a PDF certificate (currently outputs HTML).

---

## Technologies Used

- **Frontend:** HTML5, CSS3, JavaScript (ES5)
- **Backend:** JSP (JavaServer Pages), JDBC
- **Database:** PostgreSQL
- **Server:** Apache Tomcat (or any servlet container supporting JSP)
- **Other:** PostgreSQL JDBC Driver

---

## Prerequisites

- Java Development Kit (JDK) 8 or higher
- Apache Tomcat 9 (or compatible)
- PostgreSQL 12+
- A modern web browser

---

## Project Structure

├── index.html               # Landing page – enter your name
├── quiz1.jsp                # Question 1 (capital of India)
├── quiz2.jsp                # Question 2 (Father of the Nation)
├── quiz3.jsp                # Question 3 (largest planet)
├── quiz4.jsp                # Question 4 (inventor of telephone)
├── quiz5.jsp                # Question 5 (longest river)
├── quiz6.jsp                # Question 6 (Pravasi Bhartiya Divas year)
├── quiz7.jsp                # Question 7 (Vijay Singh's country)
├── quiz8.jsp                # Question 8 (DRDL full form)
├── quiz9.jsp                # Question 9 (green planet)
├── quiz10.jsp               # Question 10 (father of Indian missiles)
├── result.jsp               # Final score, answer review, DB insert
├── leaderboard.jsp          # Shows ranked results from DB
└── certificate.jsp          # (Placeholder) PDF certificate download

## How to Use

1. Open `index.html` and enter your full name.
2. Click **Start Quiz** – you will be redirected to `quiz1.jsp`.
3. For each question:
   - Select one answer.
   - The option will blink green (correct) or red (wrong) for 1.5 seconds.
   - After the blink, you are automatically taken to the next question.
   - If you do not answer within 15 seconds, the form auto‑submits (no answer is recorded).
4. After the last question, you are taken to `result.jsp` where:
   - Your score and pass/fail status are shown.
   - All your answers are displayed alongside the correct ones.
   - Your result is saved in the database.
   - Buttons allow you to view the leaderboard or download a certificate.
5. **Leaderboard** (`leaderboard.jsp`) displays all attempts sorted by score (highest first).
6. **Certificate** (`certificate.jsp`) currently outputs an HTML page with a PDF header – this is a placeholder and does not generate an actual PDF.

---

## Known Issues / Limitations

- The certificate download does **not** generate a real PDF; it merely sends HTML with a PDF content type. A proper PDF generation library (e.g., iText) is needed.
- Database credentials are hardcoded – not secure for production.
- The welcome message in `result.jsp` tries to read `fullname` from the request, which may be null (the name is actually retrieved from session correctly later).
- Timer continues even after the user has answered (visual blink may be interrupted if the timer triggers a submit). The current implementation disables the default form submission and submits after the blink, but the timer still runs and could submit early if not carefully synchronised.
- No input validation or SQL injection protection (though using `PreparedStatement` helps).

---

## Future Enhancements

- Replace hardcoded DB credentials with a configuration file.
- Implement proper PDF certificate generation.
- Add user authentication and track multiple attempts per user.
- Improve timer synchronisation and visual feedback.
- Use a responsive design for mobile devices.
- Add more questions and randomisation.

---

## Contributing

Contributions are welcome! Feel free to fork the repository and submit pull requests.

---

## License

This project is for educational purposes. You may use and modify it as needed.

---

## Contact

For questions, suggestions, or issues, please contact:

Project Maintainer: [rahulpotdar2167@gmail.com]  
GitHub Issues: [https://github.com/Rahul2167/smart_rd_system_project/issues]

**Happy Quizzing!** 🧠

