<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/same_style/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Assets/css/login_logout/register.css">

    <style>
        .error {
            color: gray;
            font-size: 13px;
            text-align: left;
            margin-top: -10px;
            margin-bottom: 10px;
            display: block;
        }
        .input.error-border { border: 2px solid red; }
        .input.success-border { border: 2px solid green; }

        .register-container {
            display: flex;
            width: 1000px;
            max-width: 95%;
            height: 600px;
            margin: 50px auto;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
            background-color: #fff;
        }

        .register-left {
            flex: 1;
            overflow: hidden;
        }
        .register-left img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
        }

        .register-right {
            flex: 1;
            padding: 50px 40px;
            background-color: #fffbfb;
            display: flex;
            flex-direction: column;
            justify-content: center;
            text-align: center;
        }

        .register-right .title {
            color: #e95221;
            margin-bottom: 15px;
            font-size: 28px;
            font-weight: bold;
        }
        .register-right p {
            margin-bottom: 20px;
        }
        .register-right a {
            color: #e95221;
            text-decoration: none;
            font-weight: bold;
        }

        .input {
            width: 100%;
            padding: 14px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #e1e1e1;
            box-sizing: border-box;
            font-size: 15px;
        }

        .button {
            width: 100%;
            padding: 15px 0;
            border-radius: 5px;
            border: 1px solid #e95221;
            background-color: #e95221;
            color: #fff;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 15px;
            font-size: 16px;
        }
        .button:hover {
            background-color: #fff;
            color: #e95221;
        }

        @media screen and (max-width: 900px) {
            .registerontainer {
                flex-direction: column;
                height: auto;
            }
            .register-left, .register-right {
                flex: unset;
                width: 100%;
                height: auto;
            }
            .register-left img {
                width: 100%;
                height: auto;
                border-radius: 0;
            }
            .register-right {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>

<jsp:include page="/Assets/component/recycleFiles/header.jsp"/>

<div class="register-container">
    <!-- Ảnh -->
    <div class="register-left">
        <img src="https://img.pikbest.com/ai/illus_our/20230529/55b6b414701fc4281268b54ef38fb1b2.jpg!w700wp" alt="Register Image">
    </div>

    <!-- Form -->
    <div class="register-right">
        <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post">

            <h2 class="title">ĐĂNG KÝ</h2>
            <p>Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login">
                    Đăng nhập
                </a>
            </p>

            <% if (session.getAttribute("msg") != null) { %>
            <div class="alert alert-info">
                <%= session.getAttribute("msg") %>
            </div>
            <% session.removeAttribute("msg"); %>
            <% } %>

            <input id="username" class="input" type="text" name="username" placeholder="Tên đăng nhập (*)" required>
            <span class="error" id="nameError"></span>

            <input id="email" class="input" type="text" name="email" placeholder="Email (*)" required>
            <span class="error" id="emailError"></span>

            <input id="phoneNum" class="input" type="text" name="phoneNum" placeholder="Số điện thoại">
            <span class="error" id="phoneError"></span>

            <input id="password" class="input" type="password" name="password" placeholder="Mật khẩu (*)" required>
            <span class="errnameRegexor" id="passError"></span>

            <input id="confirmPassword" class="input" type="password" name="confirm_password" placeholder="Nhập lại mật khẩu (*)" required>
            <span class="error" id="confirmError"></span>

            <button class="button" type="submit">ĐĂNG KÝ</button>
        </form>
    </div>
</div>

<jsp:include page="/Assets/component/recycleFiles/footer.jsp"/>

<script>
    const nameInput = document.getElementById("username");
    const emailInput = document.getElementById("email");
    const phoneInput = document.getElementById("phoneNum");
    const passwordInput = document.getElementById("password");
    const confirmInput = document.getElementById("confirmPassword");

    const nameError = document.getElementById("nameError");
    const emailError = document.getElementById("emailError");
    const phoneError = document.getElementById("phoneError");
    const passError = document.getElementById("passError");
    const confirmError = document.getElementById("confirmError");

    const nameRegex = /^[\p{L} ]+$/u;
    const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    const phoneRegex = /^0\d{9}$/;
    const passRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/;

    function showGray(element, message){
        element.innerText = message;
        element.style.color = "gray";
    }
    function setError(input, element, message){
        element.innerText = message;
        element.style.color = "red";
        input.classList.add("error-border");
        input.classList.remove("success-border");
    }
    function setSuccess(input, element){
        element.innerText = "";
        input.classList.remove("error-border");
        input.classList.add("success-border");
    }

    const inputs = [
        {input: nameInput, element: nameError, message:"Tên chỉ được chứa chữ và khoảng trắng"},
        {input: emailInput, element: emailError, message:"Email không hợp lệ"},
        {input: phoneInput, element: phoneError, message:"SĐT phải bắt đầu bằng 0 và có 10 số"},
        {input: passwordInput, element: passError, message:"≥8 ký tự gồm chữ hoa, chữ thường, số và ký tự đặc biệt"},
        {input: confirmInput, element: confirmError, message:"Mật khẩu không khớp"}
    ];

    inputs.forEach(obj=>{
        obj.input.addEventListener("focus", ()=>{
            if(obj.input.value==="") showGray(obj.element,obj.message);
        });
    });

    nameInput.addEventListener("blur", ()=>{
        if(!nameRegex.test(nameInput.value)){
            setError(nameInput,nameError,"Tên chỉ được chứa chữ và khoảng trắng");
        } else setSuccess(nameInput,nameError);
    });

    emailInput.addEventListener("blur", ()=>{
        if(!emailRegex.test(emailInput.value)){
            setError(emailInput,emailError,"Email không hợp lệ");
        } else setSuccess(emailInput,emailError);
    });

    phoneInput.addEventListener("blur", ()=>{
        let phone = phoneInput.value;
        if(phone===""){ phoneError.innerText=""; phoneInput.classList.remove("error-border"); return; }
        if(!phoneRegex.test(phone)){ setError(phoneInput,phoneError,"SĐT phải bắt đầu bằng 0 và có 10 số"); return; }
        let allSame = true;
        for(let i=1;i<phone.length;i++){ if(phone[i]!==phone[1]){ allSame=false; break; } }
        if(allSame) setError(phoneInput,phoneError,"SĐT không được lặp cùng 1 số");
        else setSuccess(phoneInput,phoneError);
    });

    passwordInput.addEventListener("blur", ()=>{
        if(!passRegex.test(passwordInput.value)){
            setError(passwordInput,passError,"≥8 ký tự gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
        } else setSuccess(passwordInput,passError);
    });

    confirmInput.addEventListener("blur", ()=>{
        if(confirmInput.value !== passwordInput.value){
            setError(confirmInput,confirmError,"Mật khẩu không khớp");
        } else setSuccess(confirmInput,confirmError);
    });
</script>

</body>
</html>