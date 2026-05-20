<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>容辰的南臺科大教學備考神器</title>
    <!-- 引入 Tailwind CSS 打造超 Chill 視覺界面 -->
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 min-h-screen font-sans">

    <!-- 頂部導覽列 -->
    <header class="bg-gradient-to-r from-blue-600 to-indigo-700 text-white shadow-lg sticky top-0 z-50">
        <div class="max-w-4xl mx-auto px-4 py-4 flex justify-between items-center">
            <div>
                <h1 class="text-xl font-bold tracking-wider">💪 G哥挺妳！備考衝刺刷題本</h1>
                <p class="text-xs opacity-80 text-blue-100">目標：80分以上！專屬 VRK 視覺動覺優化版</p>
            </div>
            <div id="score-board" class="bg-white/20 px-3 py-1.5 rounded-full text-sm font-semibold">
                得分率: <span id="accuracy">0</span>% (<span id="score">0</span>/<span id="total-answered">0</span>)
            </div>
        </div>
    </header>

    <main class="max-w-4xl mx-auto px-4 py-8 grid grid-cols-1 md:grid-cols-3 gap-6">
        
        <!-- 左側/上方：做題核心區 -->
        <div class="md:col-span-2 space-y-6">
            <!-- 題目卡片 -->
            <div id="quiz-card" class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 transition-all">
                <div class="flex justify-between items-center mb-4">
                    <span id="q-tier" class="px-2.5 py-1 rounded-md text-xs font-bold"></span>
                    <span id="q-year" class="text-xs text-gray-400 font-medium"></span>
                </div>
                <h2 id="q-text" class="text-lg font-bold text-gray-800 mb-6 leading-relaxed">正在載入題目...</h2>
                
                <!-- 選項區 -->
                <div id="options-container" class="space-y-3">
                    <!-- 動態生成選項 -->
                </div>

                <!-- 下一題按鈕 -->
                <button id="next-btn" class="hidden w-full mt-6 bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-4 rounded-xl shadow-md transition-all text-center">
                    下一題 🚀
                </button>
            </div>
        </div>

        <!-- 右側：錯題追蹤本（滿足死穴紀錄需求） -->
        <div class="space-y-6">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5">
                <h3 class="text-md font-bold text-gray-800 flex items-center gap-2 mb-3">
                    ❌ ⚠️ 錯題追蹤本 (<span id="wrong-count">0</span>)
                </h3>
                <p class="text-xs text-gray-400 mb-4">答錯的題目會自動記錄在下面，方便點選重新複習！</p>
                <div id="wrong-list" class="space-y-2 max-h-96 overflow-y-auto pr-1 text-sm">
                    <p class="text-gray-400 text-center py-4 text-xs">目前沒有錯題，保持下去！有夠讚！</p>
                </div>
            </div>
        </div>
    </main>

    <script>
        // 範例題庫（依據妳提供的各學年度考題精選，涵蓋各 Tier 弱點與新趨勢）
        const quizData = [
            {
                year: "113 學年度",
                tier: "Tier C 新趨勢 (本土元素)",
                question: "以下哪一位作家，出身台南，並且曾經寫出「台南是一個適合人們作夢、幹活、戀愛、結婚、悠然過活的地方。」形容台南宜居的特質？",
                options: ["(A) 葉石濤", "(B) 鍾肇政", "(C) 白先勇", "(D) 葉笛"],
                answer: 0,
                hint: "台南文學巨擘，葉石濤廣場就在台南文學館旁！"
            },
            {
                year: "113 學年度",
                tier: "Tier S 核心必拿 (數學因倍數)",
                question: "以下哪兩個數不互質？",
                options: ["(A) 3, 5", "(B) 16, 81", "(C) 25, 27", "(D) 17, 119"],
                answer: 3,
                hint: "17 * 7 = 119，所以兩數有公因數 17，不互質！"
            },
            {
                year: "113 學年度",
                tier: "Tier A 重點攻克 (古文形音義)",
                question: "唐代韓愈〈師說〉從理論上闡明老師的作用和向老師學習的重要性。如：「句『讀』之不知，惑之不解，或師焉，或『不』焉」。其中『讀』、『不』的正確注音是？",
                options: ["(A) ㄉㄨˊ，ㄅㄨˋ", "(B) ㄉㄨˊ，ㄈㄡˇ", "(C) ㄉㄡˋ，ㄅㄨˋ", "(D) ㄉㄡˋ，ㄈㄡˇ"],
                answer: 3,
                hint: "句讀注音為ㄉㄡˋ（句子停頓處）；『不』通『否』，讀ㄈㄡˇ。"
            },
            {
                year: "106 學年度",
                tier: "Tier B 基本常識 (音樂藝能)",
                question: "請問以下何者為 Mi 的音名？",
                options: ["(A) G", "(B) C", "(C) A", "(D) E"],
                answer: 3,
                hint: "Do=C, Re=D, Mi=E, Fa=F, Sol=G, La=A, Si=B。"
            },
            {
                year: "92 學年度",
                tier: "Tier S 核心必拿 (國文錯別字)",
                question: "下列成語何者沒有錯別字？",
                options: ["(A) 灸手可熱", "(B) 大塊朵頤", "(C) 如火如荼", "(D) 互相抵觸"],
                answer: 2,
                hint: "(A) 炙手可熱 (B) 大快朵頤 (D) 互相牴觸。只有 (C) 完全正確。"
            }
        ];

        let currentIndex = 0;
        let correctCount = 0;
        let totalAnswered = 0;
        let wrongQuestions = [];

        // DOM 元素
        const qTier = document.getElementById('q-tier');
        const qYear = document.getElementById('q-year');
        const qText = document.getElementById('q-text');
        const optionsContainer = document.getElementById('options-container');
        const nextBtn = document.getElementById('next-btn');
        const scoreEl = document.getElementById('score');
        const totalAnsweredEl = document.getElementById('total-answered');
        const accuracyEl = document.getElementById('accuracy');
        const wrongCountEl = document.getElementById('wrong-count');
        const wrongListEl = document.getElementById('wrong-list');

        function loadQuestion(index) {
            if (index >= quizData.length) {
                qText.innerHTML = "🎉 太棒了妹妹！所有範例題目都練習完畢！";
                optionsContainer.innerHTML = "";
                nextBtn.style.display = 'none';
                qTier.className = "hidden";
                return;
            }

            const currentQ = quizData[index];
            
            // 依據 Tier 著色（視覺優化）
            if(currentQ.tier.includes('Tier S')) {
                qTier.className = "px-2.5 py-1 rounded-md text-xs font-bold bg-red-100 text-red-700 border border-red-200";
            } else if(currentQ.tier.includes('Tier A')) {
                qTier.className = "px-2.5 py-1 rounded-md text-xs font-bold bg-amber-100 text-amber-700 border border-amber-200";
            } else {
                qTier.className = "px-2.5 py-1 rounded-md text-xs font-bold bg-blue-100 text-blue-700 border border-blue-200";
            }

            qTier.innerText = currentQ.tier;
            qYear.innerText = currentQ.year;
            qText.innerText = `${index + 1}. ${currentQ.question}`;
            optionsContainer.innerHTML = "";
            nextBtn.style.display = 'none';

            currentQ.options.forEach((opt, idx) => {
                const btn = document.createElement('button');
                btn.className = "w-full text-left px-5 py-3.5 rounded-xl border border-gray-200 hover:bg-gray-50 font-medium text-gray-700 transition-all focus:outline-none";
                btn.innerText = opt;
                btn.onclick = () => checkAnswer(idx, btn);
                optionsContainer.appendChild(btn);
            });
        }

        function checkAnswer(selectedIdx, clickedBtn) {
            const currentQ = quizData[currentIndex];
            const buttons = optionsContainer.getElementsByTagName('button');
            
            // 停用所有按鈕防止重複點選
            for (let btn of buttons) { btn.disabled = true; }

            totalAnswered++;

            if (selectedIdx === currentQ.answer) {
                // 答對變綠色
                clickedBtn.className = "w-full text-left px-5 py-3.5 rounded-xl border border-green-500 bg-green-50 text-green-700 font-bold transition-all";
                correctCount++;
            } else {
                // 答錯變紅色，並把正確答案標綠
                clickedBtn.className = "w-full text-left px-5 py-3.5 rounded-xl border border-red-500 bg-red-50 text-red-700 font-bold transition-all";
                buttons[currentQ.answer].className = "w-full text-left px-5 py-3.5 rounded-xl border border-green-500 bg-green-50 text-green-700 font-bold transition-all";
                
                // 加入錯題追蹤
                if(!wrongQuestions.some(q => q.question === currentQ.question)) {
                    wrongQuestions.push(currentQ);
                    updateWrongList();
                }
            }

            // 顯示解析/提示
            const hintBox = document.createElement('div');
            hintBox.className = "mt-4 p-4 rounded-xl bg-indigo-50 text-indigo-800 text-sm border border-indigo-100 leading-relaxed font-medium";
            hintBox.innerHTML = `💡 <strong>G哥筆記：</strong>${currentQ.hint}`;
            optionsContainer.appendChild(hintBox);

            // 更新記分板
            scoreEl.innerText = correctCount;
            totalAnsweredEl.innerText = totalAnswered;
            accuracyEl.innerText = Math.round((correctCount / totalAnswered) * 100);

            nextBtn.style.display = 'block';
        }

        function updateWrongList() {
            wrongCountEl.innerText = wrongQuestions.length;
            if(wrongQuestions.length === 0) {
                wrongListEl.innerHTML = `<p class="text-gray-400 text-center py-4 text-xs">目前沒有錯題，保持下去！有夠讚！</p>`;
                return;
            }
            wrongListEl.innerHTML = "";
            wrongQuestions.forEach((q, idx) => {
                const item = document.createElement('div');
                item.className = "p-3 bg-red-50/60 border border-red-100 rounded-xl text-xs text-red-800 leading-relaxed font-medium";
                item.innerText = `⚠️ [${q.year}] ${q.question.substring(0, 30)}...`;
                wrongListEl.appendChild(item);
            });
        }

        nextBtn.onclick = () => {
            currentIndex++;
            loadQuestion(currentIndex);
        };

        // 初始化第一題
        loadQuestion(currentIndex);
    </script>
</body>
</html>
