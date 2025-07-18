<%-- 
    Document   : chatbox.jsp
    Created on : Jul 3, 2025, 2:11:25 PM
    Author     : nguye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; char set=UTF-8">
    <title>Chatbox</title>
    <style>
        #chatbox-toggle {
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 1001;
            background: #1976d2;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 56px;
            height: 56px;
            font-size: 28px;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        #chatbox-container {
            position: fixed;
            bottom: 90px;
            right: 24px;
            width: 340px;
            max-height: 480px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.25);
            display: none;
            flex-direction: column;
            z-index: 1002;
            overflow: hidden;
        }
        #chatbox-header {
            background: #1976d2;
            color: #fff;
            padding: 12px 16px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        #chatbox-close {
            background: none;
            border: none;
            color: #fff;
            font-size: 20px;
            cursor: pointer;
        }
        #chatbox-messages {
            flex: 1;
            padding: 12px;
            overflow-y: auto;
            background: #f7f7f7;
            font-size: 15px;
        }
        .chat-msg {
            margin-bottom: 10px;
            display: flex;
        }
        .chat-msg.user {
            justify-content: flex-end;
        }
        .chat-msg.ai {
            justify-content: flex-start;
        }
        .chat-bubble {
            max-width: 75%;
            padding: 8px 14px;
            border-radius: 16px;
            background: #e3f2fd;
            color: #222;
            margin: 0 4px;
        }
        .chat-msg.user .chat-bubble {
            background: #1976d2;
            color: #fff;
        }
        #chatbox-form {
            display: flex;
            border-top: 1px solid #eee;
            background: #fff;
        }
        #chatbox-input {
            flex: 1;
            border: none;
            padding: 10px;
            font-size: 15px;
            outline: none;
        }
        #chatbox-send {
            background: #1976d2;
            color: #fff;
            border: none;
            padding: 0 18px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <button id="chatbox-toggle" title="Chat với AI">💬</button>
    <div id="chatbox-container">
        <div id="chatbox-header">
            Chat hỗ trợ
            <button id="chatbox-close" title="Đóng">&times;</button>
        </div>
        <div id="chatbox-messages"></div>
        <form id="chatbox-form" autocomplete="off">
            <input type="text" id="chatbox-input" placeholder="Nhập câu hỏi..." required />
            <button type="submit" id="chatbox-send">Gửi</button>
        </form>
    </div>
    <script>
        const toggleBtn = document.getElementById('chatbox-toggle');
        const chatbox = document.getElementById('chatbox-container');
        const closeBtn = document.getElementById('chatbox-close');
        const messages = document.getElementById('chatbox-messages');
        const form = document.getElementById('chatbox-form');
        const input = document.getElementById('chatbox-input');

        toggleBtn.onclick = () => {
            chatbox.style.display = 'flex';
            toggleBtn.style.display = 'none';
            input.focus();
        };
        closeBtn.onclick = () => {
            chatbox.style.display = 'none';
            toggleBtn.style.display = 'block';
        };
        function appendMsg(text, sender) {
            const msgDiv = document.createElement('div');
            msgDiv.className = 'chat-msg ' + sender;
            const bubble = document.createElement('div');
            bubble.className = 'chat-bubble';
            bubble.textContent = text;
            msgDiv.appendChild(bubble);
            messages.appendChild(msgDiv);
            messages.scrollTop = messages.scrollHeight;
        }
        form.onsubmit = async (e) => {
            e.preventDefault();
            const text = input.value.trim();
            if (!text) return;
            appendMsg(text, 'user');
            input.value = '';
            appendMsg('Đang trả lời...', 'ai');
            try {
const res = await fetch('/Itel/api/chat', {
    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ question: text })
                });
                const data = await res.json();
                messages.lastChild.remove(); // remove 'Đang trả lời...'
                appendMsg(data.answer || 'Xin lỗi, tôi không thể trả lời.', 'ai');
            } catch (err) {
                messages.lastChild.remove();
                appendMsg('Có lỗi xảy ra, vui lòng thử lại.', 'ai');
            }
        };
    </script>
</body>
</html>
