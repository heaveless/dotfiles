/* See LICENSE file for copyright and license details. */

/* fonts */
static const char *fonts[]              = { "JetBrains Mono Nerd Font:size=10" };

/* appearance */
static const unsigned int borderpx      = 1;            /* border pixel of windows */
static const unsigned int snap          = 32;           /* snap pixel */
static const unsigned int gappih        = 10;          /* horiz inner gap between windows */
static const unsigned int gappiv        = 5;           /* vert inner gap between windows */
static const unsigned int gappoh        = 5;           /* horiz outer gap between windows and screen edge */
static const unsigned int gappov        = 15;          /* vert outer gap between windows and screen edge */
static const int showbar                = 1;            /* 0 means no bar */
static const int topbar                 = 1;            /* 0 means bottom bar */
static const int vertpad                = 10;           /* vertical padding of bar */
static const int sidepad                = 10;           /* hhorizontal padding of bar */

/* colors */

static char c000000[]                   = "#000000"; // placeholder value

static char normfgcolor[]               = "#bbbbbb";
static char normbgcolor[]               = "#2e3440";
static char normbordercolor[]           = "#3b465a";
static char normfloatcolor[]            = "#3b465a";

static char selfgcolor[]                = "#33383e";
static char selbgcolor[]                = "#33383e";
static char selbordercolor[]            = "#68647b";
static char selfloatcolor[]             = "#68647b";

static char titlenormfgcolor[]          = "#bbbbbb";
static char titlenormbgcolor[]          = "#2e3440";
static char titlenormbordercolor[]      = "#32373d";
static char titlenormfloatcolor[]       = "#32373d";

static char titleselfgcolor[]           = "#eeeeee";
static char titleselbgcolor[]           = "#5e81ac";
static char titleselbordercolor[]       = "#5e81ac";
static char titleselfloatcolor[]        = "#5e81ac";

static char tagsnormfgcolor[]           = "#eeeeee";
static char tagsnormbgcolor[]           = "#2e3440";
static char tagsnormbordercolor[]       = "#ebcb8b";
static char tagsnormfloatcolor[]        = "#ebcb8b";

static char tagsselfgcolor[]            = "#2e3340";
static char tagsselbgcolor[]            = "#a3be8c";
static char tagsselbordercolor[]        = "#3f4a5e";
static char tagsselfloatcolor[]         = "#3f4a5e";

static char hidnormfgcolor[]            = "#005577";
static char hidselfgcolor[]             = "#227799";
static char hidnormbgcolor[]            = "#222222";
static char hidselbgcolor[]             = "#222222";

static char urgfgcolor[]                = "#bbbbbb";
static char urgbgcolor[]                = "#bf616a";
static char urgbordercolor[]            = "#ff0000";
static char urgfloatcolor[]             = "#bf616a";

static const char *colors[][3]      = {
	/*               fg         bg         border   */
        [SchemeNorm]         = { normfgcolor,      normbgcolor,      normbordercolor,      normfloatcolor },
	[SchemeSel]          = { selfgcolor,       selbgcolor,       selbordercolor,       selfloatcolor },
	[SchemeTitleNorm]    = { titlenormfgcolor, titlenormbgcolor, titlenormbordercolor, titlenormfloatcolor },
	[SchemeTitleSel]     = { titleselfgcolor,  titleselbgcolor,  titleselbordercolor,  titleselfloatcolor },
	[SchemeTagsNorm]     = { tagsnormfgcolor,  tagsnormbgcolor,  tagsnormbordercolor,  tagsnormfloatcolor },
	[SchemeTagsSel]      = { tagsselfgcolor,   tagsselbgcolor,   tagsselbordercolor,   tagsselfloatcolor },
	[SchemeHidNorm]      = { hidnormfgcolor,   hidnormbgcolor,   c000000,              c000000 },
	[SchemeHidSel]       = { hidselfgcolor,    hidselbgcolor,    c000000,              c000000 },
	[SchemeUrg]          = { urgfgcolor,       urgbgcolor,       urgbordercolor,       urgfloatcolor },
};

/* tagging */
static const char *tags[] = { "I", "II", "III", "IV", "V", "VI", "VII", "IIV", "IX" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
  { "Gimp",     NULL,       NULL,       0,            1,           -1 },
  { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static Key keys[] = {
	/* modifier                     key             function                argument */
	{ MODKEY,                       XK_p,           spawn,                  SHCMD("rofi -show drun") },
        { MODKEY|ShiftMask,             XK_p,           spawn,                  SHCMD("rofi -show") },
        { MODKEY|ShiftMask,             XK_s,           spawn,                  SHCMD("escrotum -sC") },
        { MODKEY|ShiftMask,             XK_r,           spawn,                  SHCMD("escrotum -rC") }, 
	{ MODKEY,                       XK_Return,      spawn,                  SHCMD("st") },
	{ MODKEY,                       XK_b,           togglebar,              {0} },
	{ MODKEY,                       XK_j,           focusstack,             {.i = +1 } },
	{ MODKEY,                       XK_k,           focusstack,             {.i = -1 } },
	{ MODKEY,                       XK_i,           incnmaster,             {.i = +1 } },
	{ MODKEY,                       XK_d,           incnmaster,             {.i = -1 } },
	{ MODKEY,                       XK_h,           setmfact,               {.f = -0.05} },
	{ MODKEY,                       XK_l,           setmfact,               {.f = +0.05} },
	{ MODKEY,                       XK_Return,      zoom,                   {0} },
	{ MODKEY,                       XK_Tab,         view,                   {0} },
	{ MODKEY|ShiftMask,             XK_c,           killclient,             {0} },
	{ MODKEY,                       XK_t,           setlayout,              {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,           setlayout,              {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,           setlayout,              {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,       setlayout,              {0} },
	{ MODKEY|ShiftMask,             XK_space,       togglefloating,         {0} },
	{ MODKEY,                       XK_0,           view,                   {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,           tag,                    {.ui = ~0 } },
	{ MODKEY,                       XK_comma,       focusmon,               {.i = -1 } },
	{ MODKEY,                       XK_period,      focusmon,               {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,       tagmon,                 {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period,      tagmon,                 {.i = +1 } },
	TAGKEYS(                        XK_1,           0)
	TAGKEYS(                        XK_2,           1)
	TAGKEYS(                        XK_3,           2)
	TAGKEYS(                        XK_4,           3)
	TAGKEYS(                        XK_5,           4)
	TAGKEYS(                        XK_6,           5)
	TAGKEYS(                        XK_7,           6)
	TAGKEYS(                        XK_8,           7)
	TAGKEYS(                        XK_9,           8)
	{ MODKEY|ShiftMask,             XK_q,           quit,                   {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          SHCMD("st") },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

