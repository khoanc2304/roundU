<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tourismapp.config.ProjectPaths" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập OTP</title>
    <style>
        /* Reset và base styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            line-height: 1.6;
        }

        /* Container styling */
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            position: relative;
            overflow: hidden;
            animation: slideInUp 0.6s ease-out;
        }

        /* Decorative element */
        .container::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #4facfe, #00f2fe);
        }

        /* Heading styles */
        h2 {
            color: #333;
            margin-bottom: 15px;
            font-size: 28px;
            font-weight: 600;
            text-align: center;
            position: relative;
        }

        h2::after {
            content: "🔐";
            display: block;
            font-size: 40px;
            margin: 10px 0 20px;
        }

        /* Subtitle text */
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
            line-height: 1.5;
        }

        /* Important note styling */
        .case-note {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 13px;
            color: #856404;
        }

        .case-note strong {
            color: #533f03;
        }

        /* Form group styling */
        .form-group {
            margin-bottom: 25px;
        }

        /* Label styling */
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
            letter-spacing: 0.5px;
            text-align: center;
        }

        /* OTP Input styling - Mixed case support */
        .form-control {
            width: 100%;
            padding: 20px;
border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            letter-spacing: 4px;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #333;
            font-family: 'Courier New', monospace;
            /* Không tự động chuyển case */
        }

        .form-control:focus {
            outline: none;
            border-color: #4facfe;
            background: white;
            box-shadow: 0 0 0 4px rgba(79, 172, 254, 0.1);
            transform: translateY(-2px);
        }

        .form-control::placeholder {
            color: #adb5bd;
            font-style: italic;
            letter-spacing: 3px;
            font-size: 18px;
        }

        /* Button container */
        .mt-3 {
            margin-top: 30px;
            text-align: center;
        }

        /* Button styling */
        .btn {
            display: inline-block;
            padding: 15px 30px;
            font-size: 16px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            min-width: 180px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(79, 172, 254, 0.4);
        }

        .btn-primary:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        }

        /* Button ripple effect */
        .btn::before {
            content: "";
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transition: width 0.6s, height 0.6s;
            transform: translate(-50%, -50%);
            z-index: 0;
        }

        .btn:active::before {
            width: 300px;
            height: 300px;
        }

        .btn span {
            position: relative;
            z-index: 1;
        }

        /* Loading state */
        .btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        /* Timer styling */
        .timer {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e1e5e9;
            color: #666;
            font-size: 14px;
        }

        .timer-count {
            font-weight: 600;
            color: #4facfe;
        }

        .resend-link {
color: #4facfe;
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .resend-link:hover {
            color: #00f2fe;
        }

        .resend-link:disabled {
            color: #adb5bd;
            cursor: not-allowed;
        }

        /* Character count indicator */
        .char-count {
            text-align: center;
            margin-top: 8px;
            font-size: 12px;
            color: #666;
        }

        .char-count.complete {
            color: #28a745;
            font-weight: 600;
        }

        /* Case indicator */
        .case-indicator {
            text-align: center;
            margin-top: 5px;
            font-size: 11px;
            color: #999;
            font-family: 'Courier New', monospace;
        }

        /* Animation cho form khi load */
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Pulse animation cho OTP input */
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(79, 172, 254, 0.4);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(79, 172, 254, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(79, 172, 254, 0);
            }
        }

        .form-control:focus {
            animation: pulse 2s infinite;
        }

        /* Focus states cho accessibility */
        .form-control:focus,
        .btn:focus {
            outline: 2px solid #4facfe;
            outline-offset: 2px;
        }

        /* Hover effect cho container */
        .container:hover {
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            transition: box-shadow 0.3s ease;
        }

        /* Success/Error message styling */
        .message {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .container {
                padding: 30px 25px;
                margin: 10px;
                max-width: 90%;
            }

            h2 {
                font-size: 24px;
            }

            .form-control {
                padding: 15px;
                font-size: 20px;
                letter-spacing: 3px;
            }

            .form-control::placeholder {
letter-spacing: 2px;
                font-size: 16px;
            }

            .btn {
                padding: 12px 25px;
                font-size: 15px;
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 15px;
            }

            .container {
                padding: 25px 20px;
            }

            h2 {
                font-size: 22px;
            }

            h2::after {
                font-size: 35px;
            }

            .form-control {
                font-size: 18px;
                letter-spacing: 2px;
            }

            .form-control::placeholder {
                letter-spacing: 1px;
                font-size: 14px;
            }
        }

        /* Custom scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(135deg, #3d8bfe, #00d4fe);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Nhập OTP</h2>
        <p class="subtitle">
            Chúng tôi đã gửi mã xác nhận 6 ký tự đến email của bạn.<br>
            Mã gồm số, chữ thường và chữ in.
        </p>
        
        <div class="case-note">
            <strong>Lưu ý:</strong> Mã OTP phân biệt chữ hoa/thường (A ≠ a)
        </div>
        
        <form action="main" method="post">
            <input type="hidden" name="action" value="verifyOtp">
            <input type="hidden" name="email" value="${requestScope.email}" />
            
            <div class="form-group">
                <label for="otp">Mã xác nhận OTP</label>
                <input type="text" class="form-control" id="otp" name="otp" 
                       placeholder="A1b2C3" maxlength="6" required />
                <div class="char-count" id="charCount">0/6 ký tự</div>
                <div class="case-indicator" id="caseIndicator">Nhập chính xác chữ hoa/thường</div>
            </div>
            
            <div class="mt-3">
                <button type="submit" class="btn btn-primary">
                    <span>Xác nhận OTP</span>
                </button>
            </div>
        </form>
        
        <div class="timer">
            Không nhận được mã? 
            <a href="#" class="resend-link" onclick="resendOTP()">Gửi lại</a>
            <div style="margin-top: 8px;">
                Mã sẽ hết hạn sau: <span class="timer-count" id="countdown">05:00</span>
            </div>
        </div>
    </div>

    <script>
        // Auto-format OTP input - Allow mixed case alphanumeric
        document.getElementById('otp').addEventListener('input', function(e) {
let value = e.target.value.replace(/[^A-Za-z0-9]/g, ''); // Chỉ cho phép chữ và số
            if (value.length > 6) value = value.slice(0, 6);
            e.target.value = value; // Giữ nguyên case gốc
            
            // Update character count
            updateCharCount(value.length);
            
            // Update case indicator
            updateCaseIndicator(value);
        });

        // Update character count display
        function updateCharCount(length) {
            const charCount = document.getElementById('charCount');
            charCount.textContent = `${length}/6 ký tự`;
            
            if (length === 6) {
                charCount.classList.add('complete');
            } else {
                charCount.classList.remove('complete');
            }
        }

        // Update case indicator to show character types
        function updateCaseIndicator(value) {
            const indicator = document.getElementById('caseIndicator');
            if (value.length === 0) {
                indicator.textContent = "Nhập chính xác chữ hoa/thường";
                return;
            }
            
            let hasUpper = /[A-Z]/.test(value);
            let hasLower = /[a-z]/.test(value);
            let hasNumber = /[0-9]/.test(value);
            
            let types = [];
            if (hasUpper) types.push("Chữ HOA");
            if (hasLower) types.push("chữ thường");
            if (hasNumber) types.push("số");
            
            if (types.length > 0) {
                indicator.textContent = `Đã nhập: ${types.join(", ")}`;
            }
        }

        // Countdown timer
        let timeLeft = 300; // 5 minutes
        const countdown = document.getElementById('countdown');
        
        function updateTimer() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            countdown.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            
            if (timeLeft <= 0) {
                countdown.textContent = "Hết hạn";
                countdown.style.color = "#dc3545";
            } else {
                timeLeft--;
                setTimeout(updateTimer, 1000);
            }
        }
        
        updateTimer();

        // Resend OTP function
        function resendOTP() {
            // Reset timer
            timeLeft = 300;
            countdown.style.color = "#4facfe";
            updateTimer();
            
            // Clear input
            document.getElementById('otp').value = '';
            updateCharCount(0);
            updateCaseIndicator('');
            
            // Here you would typically make an AJAX call to resend OTP
            alert("Mã OTP mới đã được gửi!");
        }

        // Auto-submit when 6 characters entered (optional)
        document.getElementById('otp').addEventListener('input', function(e) {
if (e.target.value.length === 6) {
                // Optional: Auto-submit form when 6 characters are entered
                // document.querySelector('form').submit();
            }
        });

        // Prevent paste of invalid characters but preserve case
        document.getElementById('otp').addEventListener('paste', function(e) {
            e.preventDefault();
            let paste = (e.clipboardData || window.clipboardData).getData('text');
            paste = paste.replace(/[^A-Za-z0-9]/g, '').slice(0, 6); // Giữ nguyên case
            this.value = paste;
            updateCharCount(paste.length);
            updateCaseIndicator(paste);
        });

        // Show caps lock warning
        document.getElementById('otp').addEventListener('keydown', function(e) {
            // Detect caps lock (this is a basic detection)
            if (e.getModifierState && e.getModifierState('CapsLock')) {
                document.getElementById('caseIndicator').textContent = "⚠️ Caps Lock đang bật";
                document.getElementById('caseIndicator').style.color = "#dc3545";
            }
        });

        document.getElementById('otp').addEventListener('keyup', function(e) {
            if (e.getModifierState && !e.getModifierState('CapsLock')) {
                updateCaseIndicator(this.value);
                document.getElementById('caseIndicator').style.color = "#999";
            }
        });
    </script>
</body>
</html>