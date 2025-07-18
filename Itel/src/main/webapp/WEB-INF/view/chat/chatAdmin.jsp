<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="chat-container">
    <div id="customer-list" style="width: 150px; float: left; margin-right: 10px; border: 1px solid #ccc; padding: 10px;"></div>
    <div id="chat-box" style="width: 400px; height: 400px; border: 1px solid #ccc; overflow-y: scroll; padding: 10px; margin-bottom: 10px;"></div>
    <input type="text" id="message-input" placeholder="Nhập tin nhắn..." style="width: 350px; padding: 5px;" />
    <button id="send-button" onclick="sendMessage()" style="padding: 5px 10px;">Gửi</button>
</div>

<script>
    let ws;
    const chatBox = document.getElementById('chat-box');
    const messageInput = document.getElementById('message-input');
    const customerList = document.getElementById('customer-list');
    let selectedCustomer = null;
    const adminId = 'admin';

    function connectWebSocket() {
        ws = new WebSocket('ws://localhost:8080/ChatApplication/chat?role=staff&userId=' + adminId);
        ws.onopen = function () {
            console.log('Connected');
            fetchCustomerList();
        };
        ws.onmessage = function (event) {
            const data = JSON.parse(event.data);
            if (data.type === 'customerList')
                updateCustomerList(data.customers);
            else if (data.type === 'message' && data.sender === selectedCustomer) {
                const messageElement = document.createElement('div');
                messageElement.textContent = `[${data.timestamp}] ${data.sender}: ${data.message}`;
                chatBox.appendChild(messageElement);
                chatBox.scrollTop = chatBox.scrollHeight;
            }
        };
        ws.onclose = function () {
            console.log('Disconnected');
        };
    }

    function fetchCustomerList() {
        fetch('/ChatApplication/ChatCustomerListServlet')
                .then(response => response.json())
                .then(data => updateCustomerList(data));
    }

    function updateCustomerList(customers) {
        customerList.innerHTML = '';
        customers.forEach(customer => {
            const customerElement = document.createElement('div');
            customerElement.className = 'customer' + (Math.random() > 0.7 ? ' new-message' : '');
            customerElement.textContent = customer;
            customerElement.onclick = () => {
                selectedCustomer = customer;
                fetch('/ChatApplication/ChatHistoryServlet?userId=' + customer)
                        .then(response => response.json())
                        .then(data => {
                            chatBox.innerHTML = '';
                            data.forEach(msg => {
                                const messageElement = document.createElement('div');
                                messageElement.textContent = `[${msg.timestamp}] ${msg.sender}: ${msg.message}`;
                                chatBox.appendChild(messageElement);
                            });
                            chatBox.scrollTop = chatBox.scrollHeight;
                        });
            };
            customerList.appendChild(customerElement);
        });
    }

    function sendMessage() {
        const message = messageInput.value;
        if (message && selectedCustomer) {
            const timestamp = new Date().toLocaleString('vi-VN');
            ws.send(JSON.stringify({type: 'message', role: 'staff', userId: adminId, message: message, target: selectedCustomer, timestamp: timestamp}));
            messageInput.value = '';
        }
    }

    messageInput.addEventListener('keypress', function (event) {
        if (event.key === 'Enter')
            sendMessage();
    });

    connectWebSocket();
</script>

<style>
    .customer {
        cursor: pointer;
        padding: 5px;
    }
    .customer:hover {
        background-color: #f0f0f0;
    }
    .new-message {
        font-weight: bold;
        color: #ff0000;
    }
</style>