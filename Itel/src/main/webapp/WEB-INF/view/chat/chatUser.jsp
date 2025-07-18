<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    .chat-toggle {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        padding: 12px 20px;
        border-radius: 25px;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        transition: all 0.3s ease;
        z-index: 1000;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .chat-toggle:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(59, 130, 246, 0.4);
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
    }

    .chat-toggle .logo {
        width: 20px;
        height: 20px;
        background: white;
        border-radius: 3px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #3b82f6;
        font-size: 12px;
    }

    .chat-container {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 360px;
        height: 500px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        z-index: 1001;
        transform: translateY(100%) scale(0.8);
        opacity: 0;
        visibility: hidden;
        transition: all 0.3s ease;
        overflow: hidden;
        border: none;
        display: flex;
        flex-direction: column;
    }

    .chat-container.active {
        transform: translateY(0) scale(1);
        opacity: 1;
        visibility: visible;
    }

    .chat-header {
        background: #4285f4;
        color: white;
        padding: 12px 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
        flex-shrink: 0;
        min-height: 60px;
    }

    .chat-header::before {
        display: none;
    }

    .chat-header-left {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .chat-header .logo {
        width: 28px;
        height: 28px;
        background: white;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        color: #4285f4;
        font-size: 14px;
        box-shadow: none;
    }

    .chat-header-info h3 {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 2px;
    }

    .chat-header-info p {
        font-size: 12px;
        opacity: 0.9;
    }

    .close-btn {
        background: none;
        border: none;
        color: white;
        font-size: 20px;
        cursor: pointer;
        padding: 5px;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
    }

    .close-btn:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: none;
    }

    .chat-body {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
        background: #f5f5f5;
        position: relative;
    }

    .chat-body::before {
        display: none;
    }

    .chat-message {
        margin-bottom: 16px;
        position: relative;
    }

    .message-content {
        background: white;
        padding: 12px 16px;
        border-radius: 16px;
        max-width: 85%;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
        line-height: 1.4;
        font-size: 14px;
        position: relative;
        border: none;
    }

    .bot-message .message-content {
        background: #4285f4;
        color: white;
        margin-left: 0;
        border: none;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    .bot-message .message-content::before {
        display: none;
    }

    .user-message {
        display: flex;
        justify-content: flex-end;
    }

    .user-message .message-content {
        background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
        color: #1e293b;
        margin-right: 0;
        border: 1px solid #cbd5e1;
    }

    .typing-indicator {
        display: none;
        padding: 8px 20px;
        font-style: italic;
        color: #64748b;
        font-size: 12px;
        background: rgba(59, 130, 246, 0.05);
        border-top: 1px solid #e2e8f0;
        position: relative;
        flex-shrink: 0;
    }

    .typing-indicator::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, #3b82f6, transparent);
    }

    .typing-indicator.show {
        display: block;
        animation: fadeInUp 0.3s ease;
    }

    .chat-input {
        padding: 16px 20px;
        background: white;
        border-top: 1px solid #e2e8f0;
        display: flex;
        align-items: center;
        gap: 10px;
        position: relative;
        flex-shrink: 0;
    }

    .chat-input::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, #3b82f6, transparent);
    }

    .chat-input input {
        flex: 1;
        padding: 12px 16px;
        border: 1px solid #cbd5e1;
        border-radius: 24px;
        font-size: 14px;
        outline: none;
        transition: all 0.2s;
        background: #f8fafc;
    }

    .chat-input input:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        background: white;
    }

    .send-btn {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        padding: 12px 16px;
        border-radius: 50%;
        cursor: pointer;
        transition: all 0.2s;
        width: 44px;
        height: 44px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        flex-shrink: 0;
    }

    .send-btn:hover {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        transform: scale(1.05);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
    }

    .send-btn:disabled {
        background: #9ca3af;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }

    .chat-body::-webkit-scrollbar {
        width: 6px;
    }

    .chat-body::-webkit-scrollbar-track {
        background: #f1f5f9;
        border-radius: 3px;
    }

    .chat-body::-webkit-scrollbar-thumb {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        border-radius: 3px;
    }

    .chat-body::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
    }

    .message-fade-in {
        animation: fadeInUp 0.4s ease;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .chat-toggle.hidden {
        opacity: 0;
        visibility: hidden;
        transform: translateY(100%);
    }

    @media (max-width: 480px) {
        .chat-container {
            width: 100vw;
            height: 100vh;
            bottom: 0;
            right: 0;
            border-radius: 0;
        }
        
        .chat-toggle {
            bottom: 20px;
            right: 20px;
        }
    }
</style>

<div class="chat-toggle" id="chatToggle">
    <div class="logo">I</div>
    <span>Itel</span>
    <span>Chat Tư Vấn</span>
</div>

<div class="chat-container" id="chatContainer">
    <div class="chat-header">
        <div class="chat-header-left">
            <div class="logo">I</div>
            <div class="chat-header-info">
                <h3>Itel</h3>
                <p>Chat Ngay</p>
            </div>
        </div>
        <button class="close-btn" id="closeChat">×</button>
    </div>

    <div class="chat-body" id="chatBody">
        <div class="chat-message bot-message">
            <div class="message-content message-fade-in">
                "ĐỪNG TỰ CHỌN - ĐỂ ITEL LỰA!" | Phần vấn không biết chọn gì? | Itel giúp bạn chọn theo nhu cầu: Game - Đồ hoạ - Học tập - Làm việc | NHẮN TIN NGAY để được tư vấn FREE & nhận nhiều ưu đãi!
            </div>
        </div>
    </div>

    <div class="typing-indicator" id="typingIndicator">
        Đang soạn tin nhắn...
    </div>

    <div class="chat-input">
        <input type="text" id="messageInput" placeholder="Nhập nội dung..." />
        <button class="send-btn" id="sendBtn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M2 21L23 12L2 3V10L17 12L2 14V21Z" fill="currentColor"/>
            </svg>
        </button>
    </div>
</div>

<script>
    let ws;
    const chatToggle = document.getElementById('chatToggle');
    const chatContainer = document.getElementById('chatContainer');
    const closeChat = document.getElementById('closeChat');
    const messageInput = document.getElementById('messageInput');
    const sendBtn = document.getElementById('sendBtn');
    const chatBody = document.getElementById('chatBody');
    const typingIndicator = document.getElementById('typingIndicator');
    const userId = '<%= session.getAttribute("userId") %>' || 'guest_' + Math.random().toString(36).substr(2, 9);

    chatToggle.addEventListener('click', () => {
        chatContainer.classList.add('active');
        chatToggle.classList.add('hidden');
        messageInput.focus();
        if (!ws) {
            connectWebSocket();
            loadChatHistory();
        }
    });

    closeChat.addEventListener('click', () => {
        chatContainer.classList.remove('active');
        chatToggle.classList.remove('hidden');
    });

    document.addEventListener('click', (e) => {
        if (!chatContainer.contains(e.target) && !chatToggle.contains(e.target)) {
            chatContainer.classList.remove('active');
            chatToggle.classList.remove('hidden');
        }
    });

    function appendMsg(text, sender) {
        const msgDiv = document.createElement('div');
        msgDiv.className = 'chat-message ' + (sender === userId ? 'user-message' : 'bot-message');
        const messageContent = document.createElement('div');
        messageContent.className = 'message-content message-fade-in';
        messageContent.textContent = text;
        msgDiv.appendChild(messageContent);
        chatBody.appendChild(msgDiv);
        chatBody.scrollTop = chatBody.scrollHeight;
    }

    function showTypingIndicator() {
        typingIndicator.classList.add('show');
        chatBody.scrollTop = chatBody.scrollHeight;
    }

    function hideTypingIndicator() {
        typingIndicator.classList.remove('show');
    }

    function connectWebSocket() {
        ws = new WebSocket('ws://localhost:8080/ChatApplication/chat?role=customer&userId=' + userId);
        ws.onopen = function () {
            console.log('Connected');
        };
        ws.onmessage = function (event) {
            hideTypingIndicator();
            const data = JSON.parse(event.data);
            if (data.type === 'message') {
                appendMsg(data.message, data.sender);
            }
        };
        ws.onclose = function () {
            console.log('Disconnected');
            hideTypingIndicator();
        };
    }

    function sendMessage() {
        const message = messageInput.value.trim();
        if (message && ws) {
            const timestamp = new Date().toLocaleString('vi-VN');
            appendMsg(message, userId);
            ws.send(JSON.stringify({type: 'message', role: 'customer', userId: userId, message: message, timestamp: timestamp}));
            messageInput.value = '';
            sendBtn.disabled = true;
            
            showTypingIndicator();
        }
    }

    sendBtn.addEventListener('click', sendMessage);

    messageInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

    messageInput.addEventListener('input', () => {
        sendBtn.disabled = !messageInput.value.trim() || !ws;
    });

    function loadChatHistory() {
        fetch('/ChatApplication/ChatHistoryServlet?userId=' + userId)
            .then(response => response.json())
            .then(data => {
                chatBody.innerHTML = '';
                
                const welcomeMsg = document.createElement('div');
                welcomeMsg.className = 'chat-message bot-message';
                welcomeMsg.innerHTML = '<div class="message-content message-fade-in">"ĐỪNG TỰ CHỌN - ĐỂ ITEL LỰA!" | Phần vấn không biết chọn gì? | Itel giúp bạn chọn theo nhu cầu: Game - Đồ hoạ - Học tập - Làm việc | NHẮN TIN NGAY để được tư vấn FREE & nhận nhiều ưu đãi!</div>';
                chatBody.appendChild(welcomeMsg);
                
                data.forEach(msg => {
                    appendMsg(msg.message, msg.sender);
                });
                chatBody.scrollTop = chatBody.scrollHeight;
            })
            .catch(error => {
                console.error('Error loading chat history:', error);
            });
    }

    sendBtn.disabled = true;
</script>