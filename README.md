♾️ Acessibilizando

Tecnologia para um mundo mais acessível, inclusivo e igualitário.
Technology for a more accessible, inclusive, and equal world.

🇧🇷 Português · 🇺🇸 English

🇧🇷 Português
♾️ Sobre o projeto

Acessibilizando é um projeto desenvolvido com o propósito de tornar informações sobre acessibilidade em locais públicos e privados mais acessíveis às pessoas que precisam delas.

A proposta é utilizar a tecnologia para ajudar pessoas a encontrarem lugares que atendam às suas necessidades de acessibilidade, permitindo também que a própria comunidade compartilhe experiências, avaliações e informações sobre esses locais.

O projeto possui uma atenção especial às necessidades de pessoas autistas, considerando aspectos que muitas vezes não são contemplados pelas formas tradicionais de avaliar acessibilidade.

🧩 Acessibilidade não é um privilégio. É um direito.

🧩 Autismo e acessibilidade

O Acessibilizando busca contribuir para um mundo onde pessoas com diferentes necessidades possam participar da sociedade com autonomia, segurança, dignidade e igualdade.

Para pessoas autistas, aspectos como:

🔊 nível de ruído;
💡 estímulos sensoriais;
🧩 características do ambiente;
♿ acessibilidade física;
🧠 previsibilidade do ambiente;
🗣️ comunicação e atendimento;

podem fazer uma diferença significativa na experiência de um determinado local.

O objetivo não é definir quais lugares são "bons" ou "ruins", mas fornecer informações que permitam que cada pessoa tome suas próprias decisões de acordo com suas necessidades.

🌎 Nossos valores
⚖️ Igualdade

Acreditamos que todas as pessoas devem ter as mesmas oportunidades de participar da sociedade, independentemente de suas características ou necessidades.

♿ Acessibilidade

Informação acessível é parte fundamental de uma sociedade acessível.

🧩 Inclusão

Diferenças não devem ser obstáculos para a participação social.

🤝 Respeito

Cada pessoa possui necessidades, experiências e perspectivas diferentes. Essas diferenças devem ser respeitadas.

🧠 Neurodiversidade

A diversidade neurológica faz parte da diversidade humana. O projeto busca contribuir para uma sociedade que reconheça e respeite diferentes formas de perceber e interagir com o mundo.

🔓 Autonomia

Informação deve ajudar as pessoas a tomar suas próprias decisões, e não decidir por elas.

🌱 Comunidade

O Acessibilizando é pensado como uma ferramenta construída com a comunidade e para a comunidade.

🗺️ Como funciona

A ideia central do projeto é permitir que usuários encontrem locais e tenham acesso a informações relacionadas à acessibilidade.

O fluxo principal é:

                    🧑 Usuário
                       │
                       ▼
                📱 Aplicativo
                 Flutter / Dart
                       │
                       │ HTTP / JSON
                       ▼
                 🌐 REST API
                Django + DRF
                       │
                       ▼
                 🗄️ PostgreSQL

Os locais podem ser associados a informações de acessibilidade e avaliados pelos usuários.

A classificação geral de um local é calculada a partir das avaliações da comunidade, permitindo que diferentes pessoas contribuam para formar uma visão coletiva sobre aquele lugar.

📍 Locais

O Acessibilizando trabalha com a ideia de separar a identidade de um local das informações de acessibilidade associadas a ele.

Isso permite que o sistema evolua futuramente para suportar diferentes tipos de informações e critérios sem precisar reconstruir toda a estrutura da aplicação.

Entre as informações consideradas pelo projeto estão características relacionadas à acessibilidade e à experiência do usuário no local.

⭐ Avaliações

As avaliações fazem parte da experiência colaborativa do Acessibilizando.

Qualquer usuário pode avaliar um local.

A classificação final do local é baseada na média das avaliações realizadas pela comunidade.

Cada usuário pode gerenciar sua própria avaliação, mantendo o controle sobre aquilo que publicou.

💬 A experiência de uma pessoa pode ajudar outra pessoa a decidir se determinado lugar é adequado para suas necessidades.

🛠️ Tecnologias

O projeto utiliza uma arquitetura separada entre aplicativo mobile, API e banco de dados.

📱 Mobile
Dart
Flutter

O aplicativo mobile será responsável pela interface utilizada pelos usuários e pela comunicação com a API.

🐍 Backend
Python
Django
Django REST Framework (DRF)

O backend concentra as regras de negócio, autenticação, gerenciamento dos usuários, locais, avaliações e informações relacionadas à acessibilidade.

A API segue uma abordagem REST, permitindo que diferentes clientes possam consumir os mesmos dados.

🗄️ Banco de dados
PostgreSQL

O PostgreSQL é utilizado como banco de dados principal da aplicação.

A escolha busca proporcionar uma base sólida para o crescimento do projeto, considerando a necessidade de armazenar usuários, locais, avaliações e diferentes informações relacionadas à acessibilidade.

🗺️ Mapas e localização

O projeto também utiliza a ideia de integração com serviços de mapas para trabalhar com locais reais.

A integração com Google Maps / Google Places permite associar os dados do Acessibilizando a lugares existentes no mundo real.

A arquitetura foi pensada para manter os dados do local separados das informações específicas de acessibilidade fornecidas pela comunidade.

🏗️ Arquitetura

O projeto segue uma arquitetura orientada a API:

┌─────────────────────────────┐
│       📱 Flutter App        │
│           Dart              │
└──────────────┬──────────────┘
               │
               │ HTTP / JSON
               ▼
┌─────────────────────────────┐
│       🌐 REST API           │
│     Django + DRF            │
│                             │
│  • Authentication           │
│  • Users                    │
│  • Places                   │
│  • Accessibility            │
│  • Reviews                  │
└──────────────┬──────────────┘
               │
               │ ORM
               ▼
┌─────────────────────────────┐
│       🗄️ PostgreSQL         │
└─────────────────────────────┘

Essa separação permite que o projeto evolua de forma independente em cada camada.

🚧 Status do projeto

🚀 Em desenvolvimento

O Acessibilizando está sendo desenvolvido de forma incremental.

Novos recursos, critérios de acessibilidade e funcionalidades serão adicionados conforme o projeto evolui.

🎯 Objetivos

O projeto busca:

♿ facilitar o acesso a informações sobre acessibilidade;
🧩 contribuir para a inclusão de pessoas autistas;
🤝 incentivar a colaboração da comunidade;
🌎 tornar informações sobre locais mais acessíveis;
🧠 considerar diferentes necessidades sensoriais e de acessibilidade;
⚖️ promover igualdade e autonomia;
💻 utilizar tecnologia para resolver um problema social real.
❤️ Por que "Acessibilizando"?

O nome representa uma ideia simples:

Estamos tornando o mundo mais acessível, um lugar de cada vez.

A acessibilidade não deve ser pensada apenas depois que um problema aparece.

Ela deve fazer parte da construção de espaços, serviços e tecnologias desde o início.

🤝 Contribuição

O Acessibilizando é um projeto que acredita na força da comunidade.

Contribuições, sugestões, ideias e críticas construtivas são bem-vindas.

Se você acredita que a tecnologia pode ajudar a construir uma sociedade mais acessível e inclusiva, você faz parte da ideia por trás deste projeto.

📜 Licença

Definir posteriormente.

🇺🇸 English
♾️ About the project

Acessibilizando is a project created with the purpose of making information about accessibility in public and private places more accessible to people who need it.

The project uses technology to help people find places that meet their accessibility needs, while also allowing the community to share experiences, ratings, and information about those places.

The project has a particular focus on the needs of autistic people, considering aspects that are often overlooked by traditional approaches to accessibility.

🧩 Accessibility is not a privilege. It is a right.

🧩 Autism and accessibility

Acessibilizando aims to contribute to a world where people with different needs can participate in society with autonomy, safety, dignity, and equality.

For autistic people, aspects such as:

🔊 noise levels;
💡 sensory stimuli;
🧩 environmental characteristics;
♿ physical accessibility;
🧠 environmental predictability;
🗣️ communication and service;

can significantly affect their experience in a particular place.

The goal is not to define which places are "good" or "bad", but to provide useful information so each person can make their own decisions according to their individual needs.

🌎 Our values
⚖️ Equality

Everyone should have equal opportunities to participate in society, regardless of their characteristics or needs.

♿ Accessibility

Accessible information is a fundamental part of an accessible society.

🧩 Inclusion

Differences should never become barriers to social participation.

🤝 Respect

Every person has different needs, experiences, and perspectives. Those differences deserve respect.

🧠 Neurodiversity

Neurological diversity is part of human diversity. The project aims to contribute to a society that recognizes and respects different ways of experiencing and interacting with the world.

🔓 Autonomy

Information should empower people to make their own decisions rather than make those decisions for them.

🌱 Community

Acessibilizando is designed as a tool built with the community and for the community.

🗺️ How it works

The core idea is to allow users to discover places and access information related to their accessibility.

The main architecture is:

                    🧑 User
                       │
                       ▼
                📱 Mobile App
                 Flutter / Dart
                       │
                       │ HTTP / JSON
                       ▼
                 🌐 REST API
                Django + DRF
                       │
                       ▼
                 🗄️ PostgreSQL

Places can be associated with accessibility information and reviewed by users.

The overall rating of a place is calculated from community reviews, allowing different users to contribute to a collective understanding of that location.

📍 Places

Acessibilizando separates the identity of a place from the accessibility information associated with it.

This approach allows the system to evolve and support different types of accessibility information and criteria without requiring the entire data structure to be rebuilt.

⭐ Reviews

Reviews are an important part of the collaborative nature of Acessibilizando.

Any user can review a place.

The final rating of a place is based on the average of the community's reviews.

Each user remains responsible for managing their own review.

💬 One person's experience can help another person decide whether a place is suitable for their needs.

🛠️ Technologies

The project uses a separated architecture consisting of a mobile application, REST API, and database.

📱 Mobile
Dart
Flutter
🐍 Backend
Python
Django
Django REST Framework (DRF)
🗄️ Database
PostgreSQL
🗺️ Maps and location
Google Maps / Google Places
🏗️ Architecture
┌─────────────────────────────┐
│       📱 Flutter App        │
│           Dart              │
└──────────────┬──────────────┘
               │
               │ HTTP / JSON
               ▼
┌─────────────────────────────┐
│       🌐 REST API           │
│     Django + DRF            │
│                             │
│  • Authentication           │
│  • Users                    │
│  • Places                   │
│  • Accessibility            │
│  • Reviews                  │
└──────────────┬──────────────┘
               │
               │ ORM
               ▼
┌─────────────────────────────┐
│       🗄️ PostgreSQL         │
└─────────────────────────────┘
🚧 Project status

🚀 In development

Acessibilizando is being developed incrementally.

New accessibility criteria, features, and improvements will be introduced as the project evolves.

🎯 Goals

The project aims to:

♿ make accessibility information easier to access;
🧩 contribute to the inclusion of autistic people;
🤝 encourage community collaboration;
🌎 make information about places more accessible;
🧠 consider different sensory and accessibility needs;
⚖️ promote equality and autonomy;
💻 use technology to address a real social problem.
❤️ Why "Acessibilizando"?

The name represents a simple idea:

We are making the world more accessible, one place at a time.

Accessibility should not be something considered only after a problem appears.

It should be part of the way we build spaces, services, and technologies from the beginning.

🤝 Contributing

Acessibilizando believes in the power of community.

Contributions, suggestions, ideas, and constructive criticism are welcome.

If you believe technology can help build a more accessible and inclusive society, you are part of the idea behind this project.

📜 License

To be defined.