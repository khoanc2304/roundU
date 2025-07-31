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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.4);
            transition: all 0.3s ease;
            animation: pulse 2s infinite;
        }
        
        #chatbox-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 25px rgba(102, 126, 234, 0.6);
        }
        
        @keyframes pulse {
            0% { box-shadow: 0 4px 20px rgba(102, 126, 234, 0.4); }
            50% { box-shadow: 0 4px 20px rgba(102, 126, 234, 0.8); }
            100% { box-shadow: 0 4px 20px rgba(102, 126, 234, 0.4); }
        }
        
        #chatbox-container {
            position: fixed;
            bottom: 100px;
            right: 24px;
            width: 380px;
            height: 500px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            display: none;
            flex-direction: column;
            z-index: 1002;
            overflow: hidden;
            border: 1px solid #e0e0e0;
        }
        
        #chatbox-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            padding: 16px 20px;
            font-weight: 600;
            font-size: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        #chatbox-close {
            background: none;
            border: none;
            color: #fff;
            font-size: 24px;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s ease;
        }
        
        #chatbox-close:hover {
            background-color: rgba(255,255,255,0.2);
        }
        
        #chatbox-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            font-size: 14px;
            line-height: 1.5;
        }
        
        .chat-msg {
            margin-bottom: 16px;
            display: flex;
            animation: fadeInUp 0.3s ease;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .chat-msg.user {
            justify-content: flex-end;
        }
        
        .chat-msg.ai {
            justify-content: flex-start;
        }
        
        .chat-bubble {
            max-width: 80%;
            padding: 12px 16px;
            border-radius: 18px;
            background: #fff;
            color: #333;
            margin: 0 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            word-wrap: break-word;
            position: relative;
        }
        
        .chat-msg.user .chat-bubble {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .chat-msg.ai .chat-bubble {
            background: #fff;
            border: 1px solid #e0e0e0;
        }
        
        .typing-indicator {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin: 0 4px;
        }
        
        .typing-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #999;
            margin: 0 2px;
            animation: typing 1.4s infinite ease-in-out;
        }
        
        .typing-dot:nth-child(1) { animation-delay: -0.32s; }
        .typing-dot:nth-child(2) { animation-delay: -0.16s; }
        
        @keyframes typing {
            0%, 80%, 100% { transform: scale(0.8); opacity: 0.5; }
            40% { transform: scale(1); opacity: 1; }
        }
        
        #chatbox-form {
            display: flex;
            border-top: 1px solid #e0e0e0;
            background: #fff;
            padding: 16px;
            gap: 8px;
        }
        
        #chatbox-input {
            flex: 1;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            padding: 12px 16px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s ease;
            background: #f8f9fa;
        }
        
        #chatbox-input:focus {
            border-color: #667eea;
            background: #fff;
        }
        
        #chatbox-send {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 44px;
            height: 44px;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        #chatbox-send:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        #chatbox-send:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }
        
        .welcome-message {
            text-align: center;
            color: #666;
            font-style: italic;
            margin: 20px 0;
            padding: 16px;
            background: rgba(255,255,255,0.8);
            border-radius: 12px;
            border: 1px dashed #ccc;
        }
    </style>
</head>
<body>
    <button id="chatbox-toggle" title="Chat với AI">🤖</button>
    <div id="chatbox-container">
        <div id="chatbox-header">
            <span>💬 AI Assistant</span>
            <button id="chatbox-close" title="Đóng">×</button>
        </div>
        <div id="chatbox-messages">
            <div class="welcome-message">
                👋 Xin chào! Tôi là AI Assistant, có thể giúp gì cho bạn?
            </div>
        </div>
        <form id="chatbox-form" autocomplete="off">
            <input type="text" id="chatbox-input" placeholder="Nhập câu hỏi của bạn..." required />
            <button type="submit" id="chatbox-send" title="Gửi tin nhắn">➤</button>
        </form>
    </div>
    <script>
        const toggleBtn = document.getElementById('chatbox-toggle');
        const chatbox = document.getElementById('chatbox-container');
        const closeBtn = document.getElementById('chatbox-close');
        const messages = document.getElementById('chatbox-messages');
        const form = document.getElementById('chatbox-form');
        const input = document.getElementById('chatbox-input');
        const sendBtn = document.getElementById('chatbox-send');

        // Khởi tạo chatbox
        let isTyping = false;

        toggleBtn.onclick = () => {
            chatbox.style.display = 'flex';
            toggleBtn.style.display = 'none';
            input.focus();
        };

        closeBtn.onclick = () => {
            chatbox.style.display = 'none';
            toggleBtn.style.display = 'block';
        };

        // Thêm tin nhắn vào chat
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

        // Hiển thị typing indicator
        function showTypingIndicator() {
            const typingDiv = document.createElement('div');
            typingDiv.className = 'chat-msg ai';
            typingDiv.id = 'typing-indicator';
            
            const typingBubble = document.createElement('div');
            typingBubble.className = 'typing-indicator';
            
            for (let i = 0; i < 3; i++) {
                const dot = document.createElement('div');
                dot.className = 'typing-dot';
                typingBubble.appendChild(dot);
            }
            
            typingDiv.appendChild(typingBubble);
            messages.appendChild(typingDiv);
            messages.scrollTop = messages.scrollHeight;
        }

        // Ẩn typing indicator
        function hideTypingIndicator() {
            const typingIndicator = document.getElementById('typing-indicator');
            if (typingIndicator) {
                typingIndicator.remove();
            }
        }

        // Xử lý gửi tin nhắn
        form.onsubmit = async (e) => {
            e.preventDefault();
            const text = input.value.trim();
            if (!text || isTyping) return;

            // Thêm tin nhắn của user
            appendMsg(text, 'user');
            input.value = '';
            
            // Disable input và button
            isTyping = true;
            input.disabled = true;
            sendBtn.disabled = true;
            
            // Hiển thị typing indicator
            showTypingIndicator();

            try {
                const res = await fetch('/Itel/api/chat-ai', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ question: text })
                });

                if (!res.ok) {
                    throw new Error(`HTTP error! status: ${res.status}`);
                }

                const data = await res.json();
                
                // Ẩn typing indicator
                hideTypingIndicator();
                
                // Thêm câu trả lời của AI
                if (data.success) {
                    appendMsg(data.answer || 'Xin lỗi, tôi không thể trả lời câu hỏi này.', 'ai');
                } else {
                    appendMsg(data.error || 'Có lỗi xảy ra, vui lòng thử lại.', 'ai');
                }
                
            } catch (err) {
                console.error('Error:', err);
                hideTypingIndicator();
                appendMsg('Có lỗi xảy ra khi kết nối với AI. Vui lòng thử lại sau.', 'ai');
            } finally {
                // Enable input và button
                isTyping = false;
                input.disabled = false;
                sendBtn.disabled = false;
                input.focus();
            }
        };

        // Xử lý phím Enter để gửi tin nhắn
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                form.dispatchEvent(new Event('submit'));
            }
        });

        // Auto focus khi mở chatbox
        toggleBtn.addEventListener('click', () => {
            setTimeout(() => input.focus(), 100);
        });

        // Đóng chatbox bằng phím Escape
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && chatbox.style.display === 'flex') {
                closeBtn.click();
            }
        });
    </script>
</body>
</html>
