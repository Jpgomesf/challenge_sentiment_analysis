-- CreateTable
CREATE TABLE "motel" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "motel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session" (
    "id" SERIAL NOT NULL,
    "motel_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "message" (
    "id" SERIAL NOT NULL,
    "motel_id" INTEGER NOT NULL,
    "session_id" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "remote" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "analysis" (
    "id" SERIAL NOT NULL,
    "session_id" INTEGER NOT NULL,
    "satisfaction" INTEGER NOT NULL,
    "summary" TEXT NOT NULL,
    "improvement" TEXT NOT NULL,
    "created_at" TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "analysis_pkey" PRIMARY KEY ("id")
);

ALTER TABLE analysis
    ADD COLUMN conversation_id VARCHAR,
    ADD COLUMN status VARCHAR,
    ADD COLUMN updated_at TIMESTAMP(0) DEFAULT CURRENT_TIMESTAMP;

CREATE INDEX analysis_conversation_id_idx ON analysis (conversation_id);
CREATE INDEX analysis_status_idx ON analysis (status);

CREATE TABLE stages (
    id SERIAL PRIMARY KEY,
    analysis_id INTEGER NOT NULL REFERENCES analysis(id),
    stage_name VARCHAR,
    status VARCHAR,
    result JSONB,
    error_details TEXT,
    started_at TIMESTAMP(0) DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP(0)
);

-- Cria índice para analysis_id na tabela stages
CREATE INDEX stages_analysis_id_idx ON stages (analysis_id);

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_motel_id_fkey" FOREIGN KEY ("motel_id") REFERENCES "motel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_motel_id_fkey" FOREIGN KEY ("motel_id") REFERENCES "motel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "message" ADD CONSTRAINT "message_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "session"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "analysis" ADD CONSTRAINT "analysis_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "session"("id") ON DELETE CASCADE ON UPDATE CASCADE;


COPY public.motel (id, name) FROM stdin;
3	Motel
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: teste_guia
--

COPY public.session (id, motel_id, created_at) FROM stdin;
3	3	2025-01-07 12:10:47
5	3	2025-01-08 13:49:28
6	3	2025-01-29 18:28:38
11	3	2025-01-12 10:51:02
13	3	2025-01-07 21:10:38
14	3	2025-01-17 00:20:38
15	3	2025-01-07 23:18:31
16	3	2025-01-27 14:12:34
17	3	2025-01-09 16:43:56
18	3	2025-01-28 14:55:35
\.


--
-- Data for Name: analysis; Type: TABLE DATA; Schema: public; Owner: teste_guia
--

COPY public.analysis (id, session_id, satisfaction, summary, improvement, created_at) FROM stdin;
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: teste_guia
--

COPY public.message (id, motel_id, session_id, content, remote, created_at) FROM stdin;
41	3	3	Olá	t	2024-11-27 21:27:48
42	3	3	Olá, Roberto! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2024-11-27 21:28:07
43	3	3	Valor	t	2024-11-27 21:28:19
44	3	3	Claro! 😊 Para verificar os valores, você poderia me informar o dia e horário em que gostaria de se hospedar?	f	2024-11-27 21:28:37
45	3	3	Hoje a noite	t	2024-11-27 21:28:49
46	3	3	Perfeito! Que horas você gostaria de se hospedar hoje à noite? 🕒	f	2024-11-27 21:29:07
47	3	3	20h	t	2024-11-27 21:29:42
48	3	3	Aqui estão as suítes disponíveis para hoje à noite:	f	2024-11-27 21:30:02
49	3	3	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 114,00 por R$ 79,80 (check-in hoje a partir das 20h / check-out hoje até 23h)\n\n- *12 horas*: de R$ 156,00 por R$ 109,20 (check-in hoje a partir das 20h / check-out amanhã até 8h)\n\n(desconto aplicado na reserva)	f	2024-11-27 21:30:04
51	3	3	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 173,00 por R$ 121,10 (check-in hoje a partir das 20h / check-out hoje até 23h)\n\n- *12 horas*: de R$ 215,00 por R$ 150,50 (check-in hoje a partir das 20h / check-out amanhã até 8h)\n\n(desconto aplicado na reserva)	f	2024-11-27 21:30:07
52	3	3	<PHOTO>\n\n*suíte infinity erótica*\n_(hidro, decoração erótica, decoração temática, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 199,00 por R$ 139,30 (check-in hoje a partir das 20h / check-out hoje até 23h)\n\n- *12 horas*: de R$ 250,00 por R$ 175,00 (check-in hoje a partir das 20h / check-out amanhã até 8h)\n\n(desconto aplicado na reserva)	f	2024-11-27 21:30:10
53	3	3	Qual suíte você quer reservar?	f	2024-11-27 21:30:12
54	3	3	Posso continuar te ajudando? 😊	f	2024-11-27 21:47:34
55	3	3	Ilusion	t	2024-11-27 22:48:43
56	3	3	Ótima escolha, Roberto! 😍 Agora, você gostaria de reservar a suíte Ilusion por 3 horas ou 12 horas? \n\n- **3 horas**: check-in hoje a partir das 20h / check-out hoje até 23h.\n- **12 horas**: check-in hoje a partir das 20h / check-out amanhã até 8h. \n\nQual período você prefere?	f	2024-11-27 22:49:03
57	3	3	3	t	2024-11-27 22:49:20
58	3	3	Perfeito! Você escolheu a suíte Ilusion por 3 horas. 🛏️✨\n\nAgora, vou confirmar suas escolhas:\n\n- **Suíte**: Ilusion\n- **Data do check-in**: 27/11/2024\n- **Horário de entrada**: 20:00\n- **Período**: 3 horas\n\nVou confirmar agora! 😊	f	2024-11-27 22:49:44
59	3	3	Sua reserva está quase pronta! 🎉\n\nVocê escolheu a suíte **Ilusion** por **3 horas**. O valor é de **R$ 121,10** (sem taxas). Lembrando que a reserva é para **2 pessoas** e não inclui café da manhã ou outras cortesias.\n\nPara finalizar a reserva, você precisa acessar o link abaixo e realizar o pagamento:\n\n👉 [Reservar Suíte Ilusion](https://go.guiademoteis.com.br/sites/irdepois/reservar/?m=2115&s=7128&p=167081913&v=173.0&tp=1&t=3&de=27%2F11%2F2024+21%3A30&customLoading=1&o=alzira)\n\nO horário de entrada foi ajustado para **21h30** para que o motel tenha tempo suficiente para preparar a suíte. \n\nSe precisar de mais alguma coisa, estou à disposição! 😊	f	2024-11-27 22:49:54
60	3	3	Quais opções do cardápio?	t	2024-11-28 00:10:13
61	3	3	Você pode acessar o cardápio completo através deste link: [Cardápio Intense Motel](https://www.intensemotel.com.br/gastronomia). \n\nPara fazer o pedido de porção, comida ou algum item do cardápio, basta tirar o telefone do gancho e a recepção irá atendê-lo. \n\nSe precisar de mais alguma coisa, é só avisar! 😊🍽️	f	2024-11-28 00:10:34
62	3	3	Tem promoção?	t	2024-11-28 00:31:23
63	3	3	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 128,00 por R$ 89,60\n\n- *12 horas*: de R$ 269,00 por R$ 188,30\n\n(desconto aplicado na reserva)	f	2024-12-07 01:38:58
64	3	3	Atualmente, temos algumas promoções disponíveis:\n\n- **Suíte Imaginarium**:\n  - 3 horas: de R$ 114,00 por R$ 79,80.\n  - 12 horas: de R$ 156,00 por R$ 109,20.\n\n- **Suíte Ilusion** (que você escolheu):\n  - 3 horas: de R$ 173,00 por R$ 121,10.\n  - 12 horas: de R$ 215,00 por R$ 150,50.\n\n- **Suíte Infinity Erótica**:\n  - 3 horas: de R$ 199,00 por R$ 139,30.\n  - 12 horas: de R$ 250,00 por R$ 175,00.\n\n- **Suíte Infinity**:\n  - 3 horas: de R$ 188,00 por R$ 131,60.\n  - 12 horas: de R$ 230,00 por R$ 161,00.\n\n- **Suíte Ilumini**:\n  - 3 horas: de R$ 210,00 por R$ 147,00.\n  - 12 horas: de R$ 265,00 por R$ 185,50.\n\nEsses são os únicos descontos oferecidos pelo motel. Se o desconto for válido na reserva online, ele será exibido no sistema de reservas. Se precisar de mais alguma informação, é só avisar! 😊	f	2024-11-28 00:31:50
118	3	3	citação: suíte infinity erótica\n\nmensagem: Essa	t	2024-12-07 01:40:26
75	3	3	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: R$ 104,00\n\n- *12 horas*: R$ 219,00	f	2024-12-07 01:38:59
92	3	3	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 184,00 por R$ 128,80\n\n- *12 horas*: de R$ 359,00 por R$ 251,30\n\n(desconto aplicado na reserva)	f	2024-12-07 01:39:01
104	3	3	Oi	t	2024-12-07 01:22:01
105	3	3	Olá, Roberto! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2024-12-07 01:22:20
106	3	3	Reservar	t	2024-12-07 01:22:52
107	3	3	Ótimo, Roberto! Para que eu possa te ajudar com a reserva, qual dia e horário você gostaria de se hospedar? 🏨✨	f	2024-12-07 01:23:10
108	3	3	Hoje	t	2024-12-07 01:36:17
109	3	3	Perfeito! É para ir agora? 🕒	f	2024-12-07 01:36:34
110	3	3	Sim	t	2024-12-07 01:38:34
111	3	3	Aqui estão as suítes disponíveis para você agora:	f	2024-12-07 01:38:56
113	3	17	Olá	t	2025-01-28 14:55:35
114	3	3	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 215,00 por R$ 150,50\n\n- *12 horas*: de R$ 409,00 por R$ 286,30\n\n(desconto aplicado na reserva)	f	2024-12-07 01:39:03
115	3	3	<PHOTO>\n\n*suíte infinity erótica*\n_(hidro, decoração erótica, decoração temática, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 226,00 por R$ 158,20\n\n- *12 horas*: de R$ 439,00 por R$ 307,30\n\n(desconto aplicado na reserva)	f	2024-12-07 01:39:06
116	3	3	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n- *3 horas*: de R$ 236,00 por R$ 165,20\n\n- *12 horas*: de R$ 459,00 por R$ 321,30\n\n(desconto aplicado na reserva)	f	2024-12-07 01:39:08
117	3	3	Qual suíte você quer reservar agora?	f	2024-12-07 01:39:10
119	3	3	Você escolheu a suíte Infinity Erótica! 🛏️✨ Agora, qual período você gostaria de reservar? As opções disponíveis são:\n\n- 3 horas: de R$ 226,00 por R$ 158,20 (com desconto)\n- 12 horas: de R$ 439,00 por R$ 307,30 (com desconto)\n\nQual você prefere?	f	2024-12-07 01:40:45
120	3	3	3h	t	2024-12-07 01:41:14
121	3	3	A sua reserva está quase pronta, Roberto! 🎉\n\nVocê escolheu a suíte Infinity Erótica por 3 horas, no valor de R$ 158,20 (sem taxas). A reserva é para 2 pessoas e será feita após o pagamento parcial.\n\nPara finalizar, acesse o link abaixo para pagar e garantir sua suíte:\n\n👉 [Reservar Suíte Infinity Erótica](https://go.guiademoteis.com.br/sites/2115/motel/imediatas/?origem=alzira)\n\nLembre-se de chegar até às 23h30. Se precisar de mais alguma coisa, é só avisar! 😊✨	f	2024-12-07 01:41:39
191	3	5	<PHOTO>\n\n*café da manhã*\n\n_café da manhã inclui café leite suco de laranja pão francês bolachas mini bolo torrada manteiga geleia requeijão iogurte queijo presunto e fruta da época_\n\npor R$ 48,00	f	2025-01-07 12:22:25
163	3	5	Olá	t	2025-01-07 12:10:47
164	3	5	Olá! 😊 Meu nome é Alzira, e estou aqui para ajudar você com tudo sobre o Intense Motel. Como posso te ajudar hoje?	f	2025-01-07 12:11:06
165	3	5	Gostaria de saber valores	t	2025-01-07 12:11:22
166	3	5	Claro! Para verificar os valores, você poderia me informar o dia e horário em que gostaria de se hospedar? 🏨✨	f	2025-01-07 12:11:40
173	3	5	A suíte "Infinity" está disponível para os seguintes períodos:\n\n- **3 horas**: R$ 131,60 (com reserva)\n- **12 horas**: R$ 161,00 (com reserva)\n\nQual período você gostaria de escolher? 😊	f	2025-01-07 12:21:31
174	3	5	12 hr	t	2025-01-07 12:21:56
179	3	5	10/01	t	2025-01-07 12:16:25
180	3	5	Ótimo! E qual horário você gostaria de se hospedar no dia 10/01? ⏰	f	2025-01-07 12:16:43
181	3	5	Meia noite	t	2025-01-07 12:17:28
182	3	5	Aqui estão as suítes disponíveis para o dia 10/01/2025 à 0h:	f	2025-01-07 12:17:51
183	3	5	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 3h_\n\nR$ 114,00 (sem reserva)\nR$ 79,80 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 12h_\n\nR$ 156,00 (sem reserva)\nR$ 109,20 (com reserva)\n	f	2025-01-07 12:17:54
184	3	5	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 3h_\n\nR$ 93,00 (sem reserva)\nR$ 93,00 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 12h_\n\nR$ 126,00 (sem reserva)\nR$ 126,00 (com reserva)\n	f	2025-01-07 12:17:57
185	3	5	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 3h_\n\nR$ 173,00 (sem reserva)\nR$ 121,10 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 12h_\n\nR$ 215,00 (sem reserva)\nR$ 150,50 (com reserva)\n	f	2025-01-07 12:18:00
186	3	5	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 3h_\n\nR$ 188,00 (sem reserva)\nR$ 131,60 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir da 0h / check-out dia 10/01 até 12h_\n\nR$ 230,00 (sem reserva)\nR$ 161,00 (com reserva)\n	f	2025-01-07 12:18:03
187	3	5	Qual suíte você quer reservar?	f	2025-01-07 12:18:04
188	3	5	Infinity	t	2025-01-07 12:21:11
189	3	5	Aqui estão as decorações e experiências disponíveis para a suíte Infinity no dia 10/01/2025:	f	2025-01-07 12:22:22
190	3	5	<PHOTO>\n\n*decoração romântica*\n\n_decoração com pétalas de rosa velas balões em formato de coração luminárias com led laços de cetim foto do casal_\n\npor R$ 150,00	f	2025-01-07 12:22:23
192	3	5	<PHOTO>\n\n*cesta de chocolates*\n\n_cesta com chocolates e pelúcia em formato de coração_\n\npor R$ 100,00	f	2025-01-07 12:22:26
193	3	5	Qual experiência você quer reservar agora?	f	2025-01-07 12:22:27
194	3	6	Bom dia	t	2025-01-07 12:28:02
195	3	6	Bom dia! ☀️ Meu nome é Alzira, e estou aqui para ajudar você com informações sobre o Intense Motel. Como posso te ajudar hoje? 😊	f	2025-01-07 12:28:22
196	3	5	Decoração romântico	t	2025-01-07 12:29:20
197	3	5	Sua reserva está quase pronta! 🎉\n\nVocê escolheu a **suíte Infinity** por **12 horas** com a **decoração romântica**. O valor total é de **R$ 161,00** (com desconto aplicado) e sem taxas. \n\nA reserva é para até **2 pessoas**. Para finalizar, você precisa acessar o link abaixo para fazer o pagamento via **pix**:\n\n👉 [Reservar Suíte Infinity](https://go.guiademoteis.com.br/sites/irdepois/reservar/?m=2115&s=7130&p=174381167&v=230.0&tp=1&t=12&e=228&de=10%2F01%2F2025+00%3A00&customLoading=1&o=alzira)\n\nA reserva será confirmada após o pagamento. Se precisar de mais alguma coisa, estou aqui! 😊✨	f	2025-01-07 12:29:49
199	3	6	queria saber sobre as suítes	t	2025-01-07 12:32:20
200	3	6	Claro! Para te ajudar melhor, você já tem uma data em mente para a sua visita ao motel? 🗓️	f	2025-01-07 12:32:38
201	3	6	10/01	t	2025-01-07 12:44:43
202	3	6	Perfeito! Vou buscar as suítes disponíveis para o dia 10/01. Um momento, por favor! ⏳	f	2025-01-07 12:45:03
203	3	6	Aqui estão as suítes disponíveis para o dia 10/01/2025 às 12h:	f	2025-01-07 12:45:08
204	3	6	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 10/01 até 15h_\n\nR$ 104,00 (sem reserva)\nR$ 104,00 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 11/01 até 0h_\n\nR$ 219,00 (sem reserva)\nR$ 219,00 (com reserva)\n\n*day-use*\n_check-in dia 10/01 a partir das 14h / check-out dia 10/01 até 18h_\n\nR$ 145,00 (com reserva)\n\n*diária*\n_check-in dia 10/01 a partir das 14h / check-out dia 11/01 até 12h_\n\nR$ 320,00 (com reserva)\n	f	2025-01-07 12:45:13
205	3	6	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 10/01 até 15h_\n\nR$ 236,00 (sem reserva)\nR$ 165,20 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 11/01 até 0h_\n\nR$ 459,00 (sem reserva)\nR$ 321,30 (com reserva)\n	f	2025-01-07 12:45:16
206	3	6	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 10/01 até 15h_\n\nR$ 128,00 (sem reserva)\nR$ 89,60 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 11/01 até 0h_\n\nR$ 269,00 (sem reserva)\nR$ 188,30 (com reserva)\n\n*day-use*\n_check-in dia 10/01 a partir das 14h / check-out dia 10/01 até 18h_\n\nR$ 170,00 (com reserva)\n\n*diária*\n_check-in dia 10/01 a partir das 14h / check-out dia 11/01 até 12h_\n\nR$ 380,00 (com reserva)\n	f	2025-01-07 12:45:20
207	3	6	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 10/01 até 15h_\n\nR$ 184,00 (sem reserva)\nR$ 128,80 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 11/01 até 0h_\n\nR$ 359,00 (sem reserva)\nR$ 251,30 (com reserva)\n\n*day-use*\n_check-in dia 10/01 a partir das 14h / check-out dia 10/01 até 18h_\n\nR$ 270,00 (com reserva)\n\n*diária*\n_check-in dia 10/01 a partir das 14h / check-out dia 11/01 até 12h_\n\nR$ 505,00 (com reserva)\n	f	2025-01-07 12:45:24
208	3	6	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n*3 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 10/01 até 15h_\n\nR$ 215,00 (sem reserva)\nR$ 150,50 (com reserva)\n\n*12 horas*\n_check-in dia 10/01 a partir das 12h / check-out dia 11/01 até 0h_\n\nR$ 409,00 (sem reserva)\nR$ 286,30 (com reserva)\n\n*day-use*\n_check-in dia 10/01 a partir das 14h / check-out dia 10/01 até 18h_\n\nR$ 305,00 (com reserva)\n\n*diária*\n_check-in dia 10/01 a partir das 14h / check-out dia 11/01 até 12h_\n\nR$ 575,00 (com reserva)\n	f	2025-01-07 12:45:29
209	3	6	Qual suíte você gostaria de reservar?	f	2025-01-07 12:45:30
210	3	6	suíte infinity	t	2025-01-07 12:46:03
211	3	6	Ótima escolha! Agora, por favor, me informe qual período você gostaria de reservar na suíte Infinity: \n\n- 3 horas\n- 12 horas\n- Day-use\n- Diária\n\nQual você prefere? 😊	f	2025-01-07 12:46:22
212	3	6	mais pessoas	t	2025-01-07 12:46:43
213	3	6	Para reservar a suíte Infinity para mais de 2 pessoas, você precisará consultar a recepção para saber o valor adicional por pessoa. \n\nVocê gostaria de seguir com a reserva para 2 pessoas e, depois, consultar a recepção sobre as taxas para as demais pessoas? 😊	f	2025-01-07 12:47:04
214	3	6	recepção	t	2025-01-07 12:47:54
215	3	6	<CONTATO Intense Motel: 11966597657>	f	2025-01-07 12:48:11
216	3	6	Você pode entrar em contato com a recepção do motel pelo telefone (11) 96659-7657 para saber sobre as taxas para mais pessoas. \n\nEnquanto isso, você gostaria de escolher um período para a suíte Infinity? 😊	f	2025-01-07 12:48:15
226	3	6	Posso continuar te ajudando com mais alguma informação ou reserva? 😊	f	2025-01-07 13:05:28
227	3	6	qual o horário do pernoite?	t	2025-01-07 13:06:15
228	3	6	Os horários do pernoite para o dia 10/01/2025 são:\n\n- **Suíte Premium**: check-in a partir das 22h / check-out até 11h do dia 11/01.\n- **Suíte Imaginarium**: check-in a partir das 22h / check-out até 11h do dia 11/01.\n- **Suíte Ilusion**: check-in a partir das 22h / check-out até 11h do dia 11/01.\n- **Suíte Infinity**: check-in a partir das 22h / check-out até 11h do dia 11/01.\n\nVocê gostaria de reservar a suíte Infinity para o pernoite? Se sim, qual horário você gostaria de entrar? 😊	f	2025-01-07 13:06:44
268	3	3	¿Puedo continuar ayudándote con tu reserva? 😊	f	2025-01-07 19:45:28
280	3	3	¡Hola, Roberto! 😊 Soy Alzira, del departamento de reservas del Intense Motel. ¿En qué día y horario te gustaría hospedarte?	f	2025-01-07 19:19:55
294	3	3	olá	t	2025-01-07 19:26:32
295	3	3	¡Hola, Roberto! 😊 ¿En qué día y horario te gustaría hospedarte en el motel?	f	2025-01-07 19:26:50
305	3	3	Reserva	t	2025-01-07 19:19:35
581	3	11	Tô querendo usar uma suíte hoje	t	2025-01-08 17:47:27
582	3	11	Ótimo, Jader! É para ir agora? 🕒	f	2025-01-08 17:47:48
583	3	11	Não	t	2025-01-08 17:47:55
584	3	11	Depois das 22:00h	t	2025-01-08 17:48:06
565	3	6	Bom dia	t	2025-01-08 15:04:59
566	3	6	Bom dia! ☀️ Meu nome é Alzira. Como posso ajudar você hoje?	f	2025-01-08 15:05:20
568	3	6	Gostaria de fazer uma reserva	t	2025-01-08 15:12:13
569	3	6	suíte ilusion	t	2025-01-08 15:12:24
570	3	6	Ótimo! 😊 Para que dia e horário você gostaria de se hospedar?	f	2025-01-08 15:12:42
571	3	6	dia 11/01 às 03:00	t	2025-01-08 15:12:48
572	3	6	Aqui estão os detalhes da suíte Ilusion:	f	2025-01-08 15:13:12
573	3	6	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in dia 11/01 a partir das 3h / check-out dia 11/01 até 6h_\n\n- R$ 184,00 (reservando antes de sair)\n- R$ 349,60 (reservando agora)\n\n\n*pernoite*\n_check-in dia 11/01 a partir das 3h / check-out dia 11/01 até 13h_\n\n- R$ 219,00 (reservando antes de sair)\n- R$ 416,10 (reservando agora)\n	f	2025-01-08 15:13:15
574	3	6	Você quer reservar essa suíte agora?	f	2025-01-08 15:13:17
575	3	6	sim	t	2025-01-08 15:13:42
576	3	6	Perfeito! Você gostaria de reservar a suíte Ilusion para o período de pernoite ou 3 horas?	f	2025-01-08 15:14:00
577	3	6	3 horas	t	2025-01-08 15:14:34
578	3	6	Sua reserva está quase pronta! 🎉\n\nVocê escolheu a suíte Ilusion para 3 horas, no dia 11/01/2025, às 03:00. O valor é de R$ 349,60 e a reserva é para até 2 pessoas.\n\nPara finalizar, acesse o link abaixo para efetuar o pagamento via Pix e concluir a reserva:\n\n👉 [Reservar Suíte Ilusion](https://go.guiademoteis.com.br/sites/irdepois/reservar/?m=2115&s=7128&p=174381132&v=184.0&tp=1&t=3&de=11%2F01%2F2025+03%3A00&customLoading=1&o=alzira)\n\nLembre-se, a reserva será confirmada após o pagamento. Se precisar de mais alguma coisa, estou aqui! 😊	f	2025-01-08 15:15:03
579	3	11	Oi	t	2025-01-08 17:46:43
580	3	11	Olá, Jader! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2025-01-08 17:47:02
585	3	11	Aqui estão as suítes disponíveis para hoje às 22h:	f	2025-01-08 17:48:28
589	3	11	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 1h_\n\n- R$ 93,00\n\n\n*12 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 10h_\n\n- R$ 126,00\n\n\n*pernoite*\n_check-in hoje a partir das 22h / check-out amanhã até 11h_\n\n- R$ 140,00 (reservando agora)\n	f	2025-01-08 17:48:31
590	3	11	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 1h_\n\n- R$ 79,80\n\n\n*12 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 10h_\n\n- R$ 109,20\n\n\n*pernoite*\n_check-in hoje a partir das 22h / check-out amanhã até 11h_\n\n- R$ 175,00 (reservando agora)\n	f	2025-01-08 17:48:35
591	3	11	<PHOTO>\n\n*suíte infinity erótica*\n_(hidro, decoração erótica, decoração temática, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 1h_\n\n- R$ 139,30\n\n\n*12 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 10h_\n\n- R$ 175,00\n	f	2025-01-08 17:48:37
592	3	11	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 1h_\n\n- R$ 147,00\n\n\n*12 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 10h_\n\n- R$ 185,50\n	f	2025-01-08 17:48:40
593	3	11	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 1h_\n\n- R$ 121,10\n\n\n*12 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 10h_\n\n- R$ 150,50\n\n\n*pernoite*\n_check-in hoje a partir das 22h / check-out amanhã até 11h_\n\n- R$ 240,00 (reservando agora)\n	f	2025-01-08 17:48:43
594	3	11	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n*3 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 1h_\n\n- R$ 131,60\n\n\n*12 horas*\n_check-in hoje a partir das 22h / check-out amanhã até 10h_\n\n- R$ 161,00\n\n\n*pernoite*\n_check-in hoje a partir das 22h / check-out amanhã até 11h_\n\n- R$ 305,00 (reservando agora)\n	f	2025-01-08 17:48:46
595	3	11	Qual suíte deseja reservar?	f	2025-01-08 17:48:48
596	3	11	Vou olhar e te retorno	t	2025-01-08 17:49:02
597	3	11	Posso chamar mais tarde ?	t	2025-01-08 17:49:13
598	3	11	Claro, Jader! Fique à vontade para me chamar quando estiver pronto. Estarei aqui para ajudar! 😊✨	f	2025-01-08 17:49:32
599	3	11	Posso te ajudar em mais alguma coisa? 😊	f	2025-01-08 18:05:11
899	3	13	Posso continuar o atendimento? 😊	f	2025-01-12 11:29:17
1269	3	15	Gostaria de saber valores de hospedagem para hoje.	t	2025-01-22 16:42:59
1019	3	13	Oi	t	2025-01-12 10:51:02
1020	3	13	Olá, Marcelo! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2025-01-12 10:51:22
1023	3	13	Qual preço pra hoje	t	2025-01-12 11:05:59
1024	3	13	Você gostaria de reservar para ir agora ou para mais tarde? 🕒	f	2025-01-12 11:06:17
1025	3	13	Agora	t	2025-01-12 11:09:01
1026	3	13	Aqui estão os detalhes da suíte disponível para ir agora:	f	2025-01-12 11:09:21
1027	3	13	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n\n⏱️ *3 horas* • R$ 184,00	f	2025-01-12 11:09:22
1028	3	13	além dessa, temos as seguintes suítes:\n\n*suíte premium* (indisponível)\n3h R$ 104,00\n\n*suíte imaginarium* (indisponível)\n3h R$ 128,00\n\n*suíte infinity* (indisponível)\n3h R$ 215,00\n\n*suíte infinity erótica* (indisponível)\n3h R$ 226,00\n\n*suíte ilumini* (indisponível)\n3h R$ 236,00\n	f	2025-01-12 11:09:25
1029	3	13	Posso reservar essa suíte para você?	f	2025-01-12 11:09:26
1080	3	15	Olá,  boa tarde!	t	2025-01-22 16:42:16
1153	3	15	<PHOTO>\n\nsuíte ilusion	f	2025-01-22 17:11:22
1270	3	15	Claro! Você gostaria de reservar para ir agora ou para mais tarde? 🕒	f	2025-01-22 16:43:17
1271	3	15	Mais tarde	t	2025-01-22 16:43:32
1170	3	14	Olá, Marco! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2025-01-17 00:20:58
1171	3	14	Quais são os melhores motéis de Contagem	t	2025-01-17 00:22:04
1272	3	15	Perfeito! Para qual horário você gostaria de fazer a reserva? 😊	f	2025-01-22 16:43:49
1273	3	15	17h	t	2025-01-22 16:44:00
1274	3	15	Seguem os valores para hoje com entrada às 17h	f	2025-01-22 16:44:23
1275	3	15	Quais or valores para suíte com hidro?	t	2025-01-22 16:44:25
1236	3	14	Olá	t	2025-01-17 00:20:38
1237	3	14	Desculpe, Marco, mas não tenho informações sobre motéis em Contagem. Posso te ajudar com informações sobre o Intense Motel em São Paulo. O que você gostaria de saber? 😊	f	2025-01-17 00:22:26
1238	3	14	Estou em belo horizonte	t	2025-01-17 00:22:52
1239	3	14	Entendi, Marco! 😊 Se precisar de informações sobre o Intense Motel em São Paulo ou se estiver pensando em visitar, estou aqui para ajudar. Você tem alguma data em mente para a sua visita?	f	2025-01-17 00:23:12
1240	3	14	Posso continuar te ajudando com mais alguma informação? 😊	f	2025-01-17 00:41:33
1241	3	14	Não	t	2025-01-17 00:42:29
1242	3	14	Tudo bem, Marco! Se precisar de algo no futuro, é só chamar. Tenha um ótimo dia! 🌟	f	2025-01-17 00:42:47
1254	3	15	<PHOTO>\n\nsuíte infinity	f	2025-01-22 17:11:22
1268	3	15	Olá! Boa tarde! 😊 Eu sou a Alzira, do Intense Motel. Como posso ajudar você hoje?	f	2025-01-22 16:42:35
1276	3	15	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 93,00 (reservando antes de sair)\nR$ 97,65 (reservando agora)\n\n⏱️ *12 horas*\nR$ 126,00 (reservando antes de sair)\nR$ 132,30 (reservando agora)	f	2025-01-22 16:44:25
1277	3	15	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 114,00 (reservando antes de sair)\nR$ 119,70 (reservando agora)\n\n⏱️ *12 horas*\nR$ 156,00 (reservando antes de sair)\nR$ 163,80 (reservando agora)	f	2025-01-22 16:44:27
1278	3	15	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 173,00 (reservando antes de sair)\nR$ 181,65 (reservando agora)\n\n⏱️ *12 horas*\nR$ 215,00 (reservando antes de sair)\nR$ 225,75 (reservando agora)	f	2025-01-22 16:44:29
1279	3	15	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 188,00 (reservando antes de sair)\nR$ 197,40 (reservando agora)\n\n⏱️ *12 horas*\nR$ 230,00 (reservando antes de sair)\nR$ 241,50 (reservando agora)	f	2025-01-22 16:44:32
1280	3	15	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 210,00 (reservando antes de sair)\nR$ 220,50 (reservando agora)\n\n⏱️ *12 horas*\nR$ 265,00 (reservando antes de sair)\nR$ 278,25 (reservando agora)	f	2025-01-22 16:44:34
1281	3	15	além dessas, temos a seguinte suíte:\n\n*suíte infinity erótica* (indisponível)\n3h R$ 208,95 - 12h R$ 262,50	f	2025-01-22 16:44:35
1282	3	15	Qual suíte deseja reservar?	f	2025-01-22 16:44:36
1283	3	15	As suítes com hidro disponíveis são:\n\n1. **Suíte Ilusion**\n   - 3 horas: R$ 181,65\n   - 12 horas: R$ 225,75\n\n2. **Suíte Infinity**\n   - 3 horas: R$ 197,40\n   - 12 horas: R$ 241,50\n\n3. **Suíte Ilumini**\n   - 3 horas: R$ 220,50\n   - 12 horas: R$ 278,25\n\n4. **Suíte Infinity Erótica** (indisponível no momento)\n\nQual delas você gostaria de escolher? 😊	f	2025-01-22 16:44:46
1284	3	15	Posso ajudar com mais alguma coisa? 😊	f	2025-01-22 17:01:53
1285	3	15	Gostaria de ver fotos das suítes	t	2025-01-22 17:11:03
1286	3	15	<PHOTO>\n\nsuíte ilumini	f	2025-01-22 17:11:23
1397	3	16	Comp faco p\nPagar?	t	2025-01-27 14:43:45
1379	3	16	Bom dia	t	2025-01-27 14:12:34
1380	3	16	Bom dia, Rodrigo! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2025-01-27 14:12:54
1381	3	16	Quais as opcoes de suites?	t	2025-01-27 14:13:44
1382	3	16	Para te informar sobre as opções de suítes, preciso saber quando você gostaria de ir ao motel. Você já tem uma data em mente? 🏨✨	f	2025-01-27 14:14:04
1383	3	16	Amanha a noite	t	2025-01-27 14:14:21
1384	3	16	Ótimo! Vou verificar a disponibilidade das suítes para amanhã à noite. Um momento, por favor. ⏳\n\nVou buscar as informações agora!	f	2025-01-27 14:14:41
1385	3	16	Seguem os valores para amanhã com entrada às 20h:	f	2025-01-27 14:14:45
1386	3	16	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 93,00 (sem reservar)\nR$ 97,65 (reservando agora)\n\n⏱️ *12 horas*\nR$ 126,00 (sem reservar)\nR$ 132,30 (reservando agora)\n\n🌙 *pernoite* • R$ 140,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:14:47
1387	3	16	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 114,00 (sem reservar)\nR$ 119,70 (reservando agora)\n\n⏱️ *12 horas*\nR$ 156,00 (sem reservar)\nR$ 163,80 (reservando agora)\n\n🌙 *pernoite* • R$ 175,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:14:50
1388	3	16	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 173,00 (sem reservar)\nR$ 181,65 (reservando agora)\n\n⏱️ *12 horas*\nR$ 215,00 (sem reservar)\nR$ 225,75 (reservando agora)\n\n🌙 *pernoite* • R$ 240,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:14:53
1389	3	16	<PHOTO>\n\n*suíte infinity erótica*\n_(hidro, decoração erótica, decoração temática, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 199,00 (sem reservar)\nR$ 208,95 (reservando agora)\n\n⏱️ *12 horas*\nR$ 250,00 (sem reservar)\nR$ 262,50 (reservando agora)	f	2025-01-27 14:14:55
1390	3	16	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 210,00 (sem reservar)\nR$ 220,50 (reservando agora)\n\n⏱️ *12 horas*\nR$ 265,00 (sem reservar)\nR$ 278,25 (reservando agora)	f	2025-01-27 14:14:57
1391	3	16	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 188,00 (sem reservar)\nR$ 197,40 (reservando agora)\n\n⏱️ *12 horas*\nR$ 230,00 (sem reservar)\nR$ 241,50 (reservando agora)\n\n🌙 *pernoite* • R$ 305,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:15:00
1392	3	16	Qual suíte você quer reservar agora?	f	2025-01-27 14:15:02
1393	3	16	Posso te ajudar com mais alguma coisa? 😊	f	2025-01-27 14:34:02
1394	3	16	Infinity	t	2025-01-27 14:38:07
1395	3	16	Você escolheu a "suíte infinity"! Agora, qual período você gostaria de reservar? As opções disponíveis são:\n\n- 3 horas (check-in a partir das 20h)\n- 12 horas (check-in a partir das 20h)\n- Pernoite (check-in a partir das 22h)\n\nQual você prefere? 🕒✨	f	2025-01-27 14:38:28
1396	3	16	Pernoite	t	2025-01-27 14:43:39
1398	3	16	Você escolheu o período de pernoite! Para reservar, o pagamento deve ser feito via PIX. \n\nAgora, vou confirmar suas escolhas:\n\n- Suíte: Infinity\n- Período: Pernoite (check-in a partir das 22h)\n\nVou confirmar essas escolhas e, em seguida, gerarei o link para você efetuar a reserva. Um momento! 😊✨	f	2025-01-27 14:44:08
1399	3	16	A reserva está quase pronta! 🎉\n\nAqui estão os detalhes:\n\n- **Suíte:** Infinity\n- **Período:** Pernoite (check-in a partir das 22h)\n- **Valor total:** R$ 305,00 (sem taxas)\n\nA reserva é para até 2 pessoas. Para finalizar, você precisa acessar o link abaixo e realizar o pagamento via PIX:\n\n👉 [Reservar Suíte Infinity](https://go.guiademoteis.com.br/sites/programadas/reservar/?m=2115&s=7130&t=2&p=482&de=28%2F01%2F2025&ds=29%2F01%2F2025&customLoading=1&o=alzira)\n\nApós o pagamento, sua reserva será confirmada. Se precisar de mais alguma coisa, estou aqui! 😊✨	f	2025-01-27 14:44:19
1400	3	16	Estava olhando agora. Nao gostei da suite. Posso mudar?	t	2025-01-27 14:47:33
1401	3	16	Claro, Rodrigo! Você pode escolher outra suíte. Vou buscar novamente as opções disponíveis para amanhã à noite. Um momento, por favor! ⏳✨	f	2025-01-27 14:47:56
1402	3	16	Seguem os valores para amanhã com entrada às 20h:	f	2025-01-27 14:48:00
1403	3	16	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 93,00 (sem reservar)\nR$ 97,65 (reservando agora)\n\n⏱️ *12 horas*\nR$ 126,00 (sem reservar)\nR$ 132,30 (reservando agora)\n\n🌙 *pernoite* • R$ 140,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:48:02
1404	3	16	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 114,00 (sem reservar)\nR$ 119,70 (reservando agora)\n\n⏱️ *12 horas*\nR$ 156,00 (sem reservar)\nR$ 163,80 (reservando agora)\n\n🌙 *pernoite* • R$ 175,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:48:05
1405	3	16	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 173,00 (sem reservar)\nR$ 181,65 (reservando agora)\n\n⏱️ *12 horas*\nR$ 215,00 (sem reservar)\nR$ 225,75 (reservando agora)\n\n🌙 *pernoite* • R$ 240,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:48:08
1406	3	16	<PHOTO>\n\n*suíte infinity erótica*\n_(hidro, decoração erótica, decoração temática, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 199,00 (sem reservar)\nR$ 208,95 (reservando agora)\n\n⏱️ *12 horas*\nR$ 250,00 (sem reservar)\nR$ 262,50 (reservando agora)	f	2025-01-27 14:48:10
1407	3	16	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 210,00 (sem reservar)\nR$ 220,50 (reservando agora)\n\n⏱️ *12 horas*\nR$ 265,00 (sem reservar)\nR$ 278,25 (reservando agora)	f	2025-01-27 14:48:13
1408	3	16	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 188,00 (sem reservar)\nR$ 197,40 (reservando agora)\n\n⏱️ *12 horas*\nR$ 230,00 (sem reservar)\nR$ 241,50 (reservando agora)\n\n🌙 *pernoite* • R$ 305,00\n> check-in amanhã a partir das 22h\n> check-out dia 29/01 até 11h	f	2025-01-27 14:48:15
1409	3	16	Qual suíte deseja reservar?	f	2025-01-27 14:48:17
1410	3	16	Vamos em 4 pessoas. E o mesmo valor?	t	2025-01-27 14:51:02
1411	3	16	Para reservas de até 2 pessoas, o valor informado é o mesmo. Para cada pessoa adicional, será cobrada uma taxa diretamente no motel. Você pode consultar a recepção para saber o valor dessa taxa.\n\nAgora, qual suíte você gostaria de escolher? Aqui estão as opções disponíveis para amanhã à noite:\n\n1. **Suíte Premium**\n   - Pernoite: R$ 140,00 (café da manhã cortesia)\n\n2. **Suíte Imaginarium**\n   - Pernoite: R$ 175,00 (café da manhã cortesia)\n\n3. **Suíte Ilusion**\n   - Pernoite: R$ 240,00 (café da manhã cortesia)\n\n4. **Suíte Infinity Erótica**\n   - Não disponível para pernoite.\n\n5. **Suíte Ilumini**\n   - Não disponível para pernoite.\n\nQual delas você gostaria de escolher? 😊✨	f	2025-01-27 14:51:28
1412	3	16	Ilumini para 4 pessoas	t	2025-01-27 14:52:18
1413	3	16	A suíte "Ilumini" não está disponível para pernoite. Você gostaria de escolher outra suíte? Aqui estão as opções novamente:\n\n1. **Suíte Premium**\n   - Pernoite: R$ 140,00 (café da manhã cortesia)\n\n2. **Suíte Imaginarium**\n   - Pernoite: R$ 175,00 (café da manhã cortesia)\n\n3. **Suíte Ilusion**\n   - Pernoite: R$ 240,00 (café da manhã cortesia)\n\nQual delas você prefere? 😊✨	f	2025-01-27 14:52:40
1414	3	16	Ilusion	t	2025-01-27 15:00:27
1415	3	16	Você escolheu a "Suíte Ilusion"! Agora, vamos confirmar os detalhes:\n\n- **Suíte:** Ilusion\n- **Período:** Pernoite (check-in a partir das 22h)\n- **Valor total:** R$ 240,00 (café da manhã cortesia)\n\nLembre-se de que para 4 pessoas, será cobrada uma taxa adicional diretamente no motel. \n\nVou confirmar suas escolhas e gerar o link para você efetuar a reserva. Um momento! 😊✨	f	2025-01-27 15:00:51
1419	3	16	A sua reserva está quase pronta, Rodrigo! 🥳\n\nAqui estão os detalhes:\n- **Suíte:** Ilusion\n- **Período:** Pernoite (check-in a partir das 22h)\n- **Valor total:** R$ 240,00 (sem taxas)\n\nLembre-se que a reserva é para até 2 pessoas, e você deve pagar a taxa adicional diretamente no motel para as outras 2 pessoas.\n\nPara finalizar a reserva, acesse o link abaixo e faça o pagamento via PIX:\n\n👉 [Reservar Suíte Ilusion](https://go.guiademoteis.com.br/sites/programadas/reservar/?m=2115&s=7128&t=2&p=482&de=28%2F01%2F2025&ds=29%2F01%2F2025&customLoading=1&o=alzira)\n\nA reserva será confirmada após o pagamento. Se precisar de mais alguma coisa, estou aqui para ajudar! 😊✨	f	2025-01-27 15:01:02
1472	3	18	Olá	t	2025-01-29 18:28:38
1473	3	18	Gostaria de fazer uma reserva	t	2025-01-29 18:28:44
1432	3	17	Olá, Jefferson! 😊 Eu sou a Alzira, do Intense Motel. Como posso te ajudar hoje?	f	2025-01-28 14:55:56
1433	3	17	Posso continuar te ajudando?	f	2025-01-28 15:14:02
1434	3	17	Gostaria de ver fotos das suites	t	2025-01-28 15:14:34
1435	3	17	Claro, Jefferson! Para isso, você pode me dizer quais suítes você gostaria de ver as fotos? 😊	f	2025-01-28 15:14:52
1436	3	17	Todas	t	2025-01-28 15:15:04
1437	3	17	<PHOTO>\n\nsuíte premium	f	2025-01-28 15:15:24
1438	3	17	<PHOTO>\n\nsuíte imaginarium	f	2025-01-28 15:15:24
1439	3	17	<PHOTO>\n\nsuíte soft	f	2025-01-28 15:15:25
1440	3	17	<PHOTO>\n\nsuíte ilusion	f	2025-01-28 15:15:25
1441	3	17	<PHOTO>\n\nsuíte infinity	f	2025-01-28 15:15:26
1442	3	17	<PHOTO>\n\nsuíte infinity erótica	f	2025-01-28 15:15:26
1443	3	17	<PHOTO>\n\nsuíte ilumini	f	2025-01-28 15:15:27
1474	3	18	Olá! 😊 Meu nome é Alzira e estou aqui para ajudar você com a sua reserva no Intense Motel. \n\nQual dia e horário você gostaria de se hospedar? 🏨✨	f	2025-01-29 18:29:07
1475	3	18	Para sábado, as 19horas	t	2025-01-29 18:30:56
1476	3	18	Seguem os valores para dia 01/02 com entrada às 19h:	f	2025-01-29 18:31:19
1477	3	18	<PHOTO>\n\n*suíte infinity erótica*\n_(hidro, decoração erótica, decoração temática, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 226,00 (sem reservar)\nR$ 282,50 (reservando agora)	f	2025-01-29 18:31:21
1478	3	18	<PHOTO>\n\n*suíte ilumini*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 236,00 (sem reservar)\nR$ 295,00 (reservando agora)	f	2025-01-29 18:31:23
1479	3	18	<PHOTO>\n\n*suíte premium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 104,00 (sem reservar)\nR$ 130,00 (reservando agora)\n\n🛏️ *diária* • R$ 320,00\n> check-in dia 01/02 a partir das 14h\n> check-out dia 02/02 até 12h	f	2025-01-29 18:31:25
1480	3	18	<PHOTO>\n\n*suíte imaginarium*\n_(garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 128,00 (sem reservar)\nR$ 160,00 (reservando agora)\n\n🛏️ *diária* • R$ 380,00\n> check-in dia 01/02 a partir das 14h\n> check-out dia 02/02 até 12h	f	2025-01-29 18:31:28
1481	3	18	<PHOTO>\n\n*suíte ilusion*\n_(hidro, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 184,00 (sem reservar)\nR$ 230,00 (reservando agora)\n\n🛏️ *diária* • R$ 505,00\n> check-in dia 01/02 a partir das 14h\n> check-out dia 02/02 até 12h	f	2025-01-29 18:31:30
1482	3	18	<PHOTO>\n\n*suíte infinity*\n_(hidro, cadeira erótica, garagem privativa, frigobar, ar-condicionado, internet wi-fi e secador de cabelo)_\n\n⏱️ *3 horas*\nR$ 215,00 (sem reservar)\nR$ 268,75 (reservando agora)\n\n🛏️ *diária* • R$ 575,00\n> check-in dia 01/02 a partir das 14h\n> check-out dia 02/02 até 12h	f	2025-01-29 18:31:32
1483	3	18	Qual suíte você quer reservar agora?	f	2025-01-29 18:31:34
1484	3	18	Infinity	t	2025-01-29 18:32:27
1485	3	18	Você escolheu a "suíte infinity"! 🥳\n\nAgora, você gostaria de reservar por 3 horas ou pela diária?	f	2025-01-29 18:32:46
1486	3	18	Diária	t	2025-01-29 18:32:56
1487	3	18	Ótima escolha! A diária na "suíte infinity" é a partir das 14h do dia 01/02/2025 e o check-out é até às 12h do dia 02/02/2025. \n\nAgora, vamos buscar as decorações ou experiências disponíveis para a suíte. Um momento! ✨	f	2025-01-29 18:33:22
1488	3	18	Aqui estão as decorações e experiências disponíveis para a suíte infinity:	f	2025-01-29 18:33:27
1489	3	18	<PHOTO>\n\n*decoração romântica*\n\n_decoração com pétalas de rosa velas balões em formato de coração luminárias com led laços de cetim foto do casal_\n\npor R$ 150,00	f	2025-01-29 18:33:29
1490	3	18	<PHOTO>\n\n*café da manhã*\n\n_café da manhã inclui café leite suco de laranja pão francês bolachas mini bolo torrada manteiga geleia requeijão iogurte queijo presunto e fruta da época_\n\npor R$ 48,00	f	2025-01-29 18:33:30
1491	3	18	<PHOTO>\n\n*cesta de chocolates*\n\n_cesta com chocolates e pelúcia em formato de coração_\n\npor R$ 100,00	f	2025-01-29 18:33:32
1492	3	18	Qual experiência você quer reservar?	f	2025-01-29 18:33:33
1493	3	18	nenhuma	t	2025-01-29 18:35:16
1494	3	18	Sem problemas! 😊\n\nVamos confirmar suas escolhas:\n\n- Suíte: **Infinity**\n- Período: **Diária**\n- Decoração/Experiência: **Nenhuma**\n\nVou confirmar essas escolhas agora. Um momento! 🕒	f	2025-01-29 18:35:37
1495	3	18	A sua reserva está quase pronta! 🎉\n\nAqui estão os detalhes:\n- Suíte: **Infinity**\n- Período: **Diária**\n- Valor total: **R$ 575,00** (sem taxas)\n- A reserva é para até **2 pessoas**.\n\nPara finalizar a reserva, você precisa acessar o link abaixo e realizar o pagamento:\n\n👉 [Reservar Suíte Infinity](https://go.guiademoteis.com.br/sites/programadas/reservar/?m=2115&s=7130&t=4&p=1896&de=01%2F02%2F2025&ds=02%2F02%2F2025&customLoading=1&o=alzira)\n\nApós o pagamento, a reserva será confirmada no Intense Motel. Se precisar de mais alguma coisa, estou aqui para ajudar! 😊	f	2025-01-29 18:35:53
1496	3	18	somente isso , obrigada	t	2025-01-29 18:36:47
1497	3	18	De nada! 😊 Se precisar de mais alguma coisa no futuro, não hesite em me chamar. Tenha uma ótima estadia no Intense Motel! 🏨✨ Até mais!	f	2025-01-29 18:37:06
\.


--
-- Name: analysis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: teste_guia
--

SELECT pg_catalog.setval('public.analysis_id_seq', 1, false);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: teste_guia
--

SELECT pg_catalog.setval('public.message_id_seq', 1497, true);


--
-- Name: motel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: teste_guia
--

SELECT pg_catalog.setval('public.motel_id_seq', 1, false);


--
-- Name: session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: teste_guia
--

SELECT pg_catalog.setval('public.session_id_seq', 18, true);


--
-- PostgreSQL database dump complete
--

