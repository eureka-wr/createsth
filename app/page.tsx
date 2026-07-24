const projects = [
  {
    index: "01",
    title: "小猫电视台",
    english: "Cat TV",
    status: "Prototype",
    description: "专门给猫咪看的内容频道。用移动、色彩和声音，探索什么样的屏幕内容真的能吸引猫。",
    tags: ["Pet Experience", "Content Experiment"],
    visual: "tv",
  },
  {
    index: "02",
    title: "小猫游戏机",
    english: "Cat Arcade",
    status: "Live",
    description: "给小猫玩的钓鱼池互动游戏。可以按年龄和性格调整节奏，让触碰、躲藏与反馈更适合不同猫咪。",
    tags: ["Mini Game", "Interaction"],
    visual: "arcade",
    url: "https://game.catv.space",
  },
  {
    index: "03",
    title: "站一下",
    english: "Stand for a moment",
    status: "Live",
    description: "为久坐办公的人设计的微休息工具。在合适的时刻提醒你站起来、活动一下，再继续专注。",
    tags: ["Tiny Tool", "Wellbeing"],
    visual: "stand",
    url: "https://tiny.catv.space",
  },
  {
    index: "04",
    title: "小猫文学输入器",
    english: "Cat Literature Editor",
    status: "Live",
    description: "把日常对白写成一段小猫文学。编辑聊天角色、语气与故事细节，并导出一张完整长图。",
    tags: ["Creative Tool", "Storytelling"],
    visual: "chat",
    url: "https://chat.catv.space",
  },
];

const learningNotes = [
  {
    date: "07.22",
    type: "PRODUCT ITERATION",
    title: "把一次提醒，改成真正愿意执行的动作",
    copy: "我重新调整了“站一下”的提醒文案和节奏：少一点命令，多一个具体而轻松的下一步。",
  },
  {
    date: "07.19",
    type: "AI WORKFLOW",
    title: "先让 AI 帮我做三个很小的版本",
    copy: "面对模糊想法，不再急着找到唯一答案。先快速比较三个方向，再决定什么值得继续。",
  },
  {
    date: "07.15",
    type: "LEARNING NOTE",
    title: "公开学习，不需要等到已经成为专家",
    copy: "记录一次修改、一个没做好的地方、一个新发现，也是在建立自己的方法。进步可以被看见。",
  },
];

const nextSteps = [
  {
    number: "01",
    title: "把猫咪产品做得更真实",
    description: "继续验证猫咪会不会看、会不会玩，而不只是让产品看起来可爱。",
    why: "WHY — 好体验应该从真正的使用者出发，哪怕使用者是一只猫。",
  },
  {
    number: "02",
    title: "做更多小而有用的工具",
    description: "聚焦工作、休息和日常生活里那些很小、却反复出现的摩擦。",
    why: "WHY — 一个恰到好处的小工具，也可以长期改变人的状态。",
  },
  {
    number: "03",
    title: "找到可以一起创造的人",
    description: "和产品、内容、AI、设计或宠物领域的人交换想法，快速做出实验。",
    why: "WHY — 不同视角相遇时，模糊的想法更容易长成真正的东西。",
  },
];

export default function Home() {
  return (
    <main>
      <header className="site-header" id="home">
        <div className="shell nav-wrap">
          <a className="brand" href="#home" aria-label="返回 Home">
            <span className="brand-mark">S</span>
            <span>STILL TRYING</span>
          </a>
          <nav className="nav-links" aria-label="页面导航">
            <a href="#home">Home</a>
            <a href="#playground">My Playground</a>
            <a href="#learning">Learn in Public</a>
            <a href="#next-step">Next Step</a>
            <a className="nav-join" href="#join-me">Join Me <span>↗</span></a>
          </nav>
        </div>
      </header>

      <section className="hero shell" aria-labelledby="hero-title">
        <div className="hero-copy">
          <p className="section-id">HOME / WHO I AM</p>
          <h1 id="hero-title">Life is too interesting<br />to stop <em>trying.</em></h1>
          <p className="hero-lead">
            你好，我是一个持续动手的产品创作者。我正在学习 AI，也在把好奇心变成
            小游戏、轻量工具和可以被真实使用的体验。
          </p>
          <p className="hero-support">
            我关心人的日常感受、人与技术如何协作，也喜欢那些有一点趣味、
            但能认真解决问题的产品。
          </p>
          <div className="hero-actions">
            <a className="button button-dark" href="#playground">See what I&apos;m making <span>↓</span></a>
            <a className="inline-link" href="#join-me">Discuss an idea <span>↗</span></a>
          </div>
          <div className="interest-row" aria-label="我感兴趣的方向">
            <span>AI × Human Creativity</span>
            <span>Playful Products</span>
            <span>Calm Tools</span>
            <span>Pet Interaction</span>
          </div>
        </div>

        <figure className="hero-figure">
          <div className="image-frame">
            <img
              src="/hero-jessica.jpg"
              alt="创作者坐在电脑前工作并看向镜头"
            />
            <span className="image-index">01 / WORK IN PROGRESS</span>
          </div>
          <figcaption>
            <span>Currently</span>
            Learning AI, building small products,<br />and sharing what changes along the way.
          </figcaption>
        </figure>
      </section>

      <section className="capability-band" aria-labelledby="capability-title">
        <div className="shell capability-grid">
          <div className="capability-intro">
            <p className="section-id light">WHAT I CAN BRING</p>
            <h2 id="capability-title">从想法到<br />可体验的版本</h2>
          </div>
          <article><span>01</span><h3>产品思考</h3><p>澄清问题、目标用户和真正值得验证的部分。</p></article>
          <article><span>02</span><h3>快速原型</h3><p>用尽可能小的成本，让想法尽快变得可体验。</p></article>
          <article><span>03</span><h3>AI 共创</h3><p>把 AI 放进探索、制作和迭代的实际工作流。</p></article>
          <article><span>04</span><h3>内容表达</h3><p>讲清楚产品为什么存在，也记录它如何成长。</p></article>
        </div>
      </section>

      <section className="page-section shell" id="playground" aria-labelledby="playground-title">
        <div className="section-heading">
          <div>
            <p className="section-id">01 / THINGS I&apos;M MAKING</p>
            <h2 id="playground-title">My Playground</h2>
          </div>
          <p>
            这是我的实验场：从宠物互动到日常效率，用小项目理解用户、技术和产品之间的关系。
          </p>
        </div>

        <div className="project-grid">
          {projects.map((project) => (
            <article className="project-card" key={project.index}>
              <div className="project-meta">
                <span>{project.index}</span>
                <span className="project-status"><i /> {project.status}</span>
              </div>
              <div
                className={`project-preview ${project.visual}`}
                aria-hidden={project.url ? undefined : true}
              >
                {project.visual === "tv" && (
                  <div className="tv-unit">
                    <div className="tv-screen"><span>CAT TV</span><b>• ᴥ •</b></div>
                    <div className="tv-controls"><i /><i /></div>
                  </div>
                )}
                {project.visual === "arcade" && (
                  <div className="arcade-unit">
                    <div className="arcade-screen"><i /><i /><i /></div>
                    <div className="arcade-controls"><b>＋</b><span><i /><i /></span></div>
                  </div>
                )}
                {project.visual === "stand" && (
                  <div className="stand-unit">
                    <div className="timer-ring"><span>25</span><small>MIN</small></div>
                    <p>TIME TO MOVE</p>
                  </div>
                )}
                {project.visual === "chat" && (
                  <div className="chat-unit">
                    <div className="chat-title"><i /> CAT LITERATURE</div>
                    <div className="chat-bubble cat-message">小猫才没有等你</div>
                    <div className="chat-bubble human-message">那我抱一下？</div>
                    <div className="chat-bubble cat-message short">只准三分钟。</div>
                  </div>
                )}
                {project.url && (
                  <a
                    className="project-preview-link"
                    href={project.url}
                    target="_blank"
                    rel="noreferrer"
                    aria-label={`访问${project.title}`}
                  >
                    <span>Open project ↗</span>
                  </a>
                )}
              </div>
              <p className="project-english">{project.english}</p>
              <h3>{project.title}</h3>
              <p className="project-description">{project.description}</p>
              <div className="tag-row">{project.tags.map((tag) => <span key={tag}>{tag}</span>)}</div>
              <a
                className="project-link"
                href={project.url ?? "#join-me"}
                target={project.url ? "_blank" : undefined}
                rel={project.url ? "noreferrer" : undefined}
              >
                {project.url ? "Visit project" : "View concept"} <span>↗</span>
              </a>
            </article>
          ))}
        </div>

        <a className="more-row" href="#join-me">
          <span className="more-label">MORE</span>
          <div><strong>更多正在发生的小实验</strong><p>一些还不完整，但已经值得开始的想法。</p></div>
          <span className="more-arrow">↗</span>
        </a>
      </section>

      <section className="learning-section" id="learning" aria-labelledby="learning-title">
        <div className="shell">
          <div className="learning-heading">
            <div>
              <p className="section-id">02 / KEEP LEARNING, KEEP SHIPPING</p>
              <h2 id="learning-title">Learn in Public</h2>
            </div>
            <div className="learning-purpose">
              <p>
                我记录学习 AI 和制作产品时的修改、判断与小进步。它们不一定是结论，
                但能证明学习可以一点点发生。
              </p>
              <span><i /> UPDATED REGULARLY</span>
            </div>
          </div>

          <div className="learning-layout">
            <aside className="learning-quote">
              <p>“不必等到准备好。<br />做一点，分享一点，<br />再多理解一点。”</p>
              <span>MY LEARNING PRINCIPLE</span>
            </aside>
            <div className="learning-list">
              {learningNotes.map((note) => (
                <article className="learning-note" key={note.date}>
                  <div className="learning-date"><time>{note.date}</time><span>{note.type}</span></div>
                  <div><h3>{note.title}</h3><p>{note.copy}</p></div>
                  <span className="note-arrow">↗</span>
                </article>
              ))}
              <a className="all-notes" href="#join-me">See all learning notes <span>↗</span></a>
            </div>
          </div>
        </div>
      </section>

      <section className="page-section shell" id="next-step" aria-labelledby="next-title">
        <div className="section-heading next-heading">
          <div>
            <p className="section-id">03 / WHERE I&apos;M GOING</p>
            <h2 id="next-title">Next Step</h2>
          </div>
          <p>
            下一步不是一份固定路线图，而是几个我愿意长期验证的方向，以及我为什么想做它们。
          </p>
        </div>

        <div className="next-grid">
          {nextSteps.map((step) => (
            <article className="next-card" key={step.number}>
              <span className="next-number">{step.number}</span>
              <h3>{step.title}</h3>
              <p>{step.description}</p>
              <strong>{step.why}</strong>
            </article>
          ))}
        </div>
      </section>

      <section className="join-section" id="join-me" aria-labelledby="join-title">
        <div className="shell join-grid">
          <div>
            <p className="section-id light">04 / OPEN TO COLLABORATION</p>
            <h2 id="join-title">Let&apos;s build together!</h2>
          </div>
          <div className="join-content">
            <h3>如果你也想创造点什么，<br />我们可以先从一次对话开始。</h3>
            <p>
              欢迎来聊产品想法、AI 原型、有趣的宠物体验，或一个你还没有完全想清楚的问题。
              可以合作，也可以只是交换观点。
            </p>
            <div className="collaboration-topics">
              <span>Product Collaboration</span>
              <span>AI Prototyping</span>
              <span>Pet Experience</span>
              <span>Creative Conversation</span>
            </div>
            <a className="button button-light" href="mailto:jessica@relife365.cn">Start a conversation <span>↗</span></a>
            <p className="email-placeholder">jessica@relife365.cn</p>
            <div className="contact-divider">
              <span>OR SCAN TO CONNECT</span>
            </div>
            <div className="contact-cards" aria-label="扫码联系 Jessica">
              <figure className="contact-card">
                <figcaption>
                  <span>飞书</span>
                  <small>LARK</small>
                </figcaption>
                <img
                  src="/contact-lark.jpg"
                  alt="Jessica 的飞书联系人二维码"
                />
              </figure>
              <figure className="contact-card">
                <figcaption>
                  <span>微信</span>
                  <small>WECHAT</small>
                </figcaption>
                <img
                  src="/contact-wechat.jpg"
                  alt="Jessica 的微信联系人二维码"
                />
              </figure>
            </div>
          </div>
        </div>
      </section>

      <footer className="footer shell">
        <p>STILL TRYING — A PERSONAL MAKING PRACTICE</p>
        <p>© 2026</p>
        <a href="#home">BACK TO HOME ↑</a>
      </footer>
    </main>
  );
}
