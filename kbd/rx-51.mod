default partial alphanumeric_keys
xkb_symbols "common" {
    include "nokia_vndr/rx-51(common_keys)"
    include "nokia_vndr/rx-51(modifiers)"

    // This section should not be included by any other section.
    // It's referenced only once by rule file to allow multiple layout configurations.

    // More than one layout at the same time could be set for instance as follows:
    // setxkbmap -rules evdev \
    //           -model nokiarx51 \
    //           -option grp:ctrl_shift_toggle \
    //           -layout us,cz \
    //           -variant ",qwerty"

    // Notice the similarity:
    //   "pc+us+cz(qwerty):2+grp:XYZ" vs.
    //   "nokia_vndr/rx-51(common)+nokia_vndr/rx-51(us)+nokia_vndr/rx-51(cz_qwerty):2+grp:XYZ"
    // where XYZ is one of xkb_symbols section usually located in file symbols/group.

    // Bear in mind that option XYZ could replace current keys configuration!!!

    // For instance using symbols/group(ctrl_shift_toggle) redefines LCTL and LFSH keys
    // which may disallow opening of virtual symbol table (Multi_key).
    // Fortunately the Multi_key is defined in 3rd and 4th level a ctrl_shift_toggle
    // redefines first two levels only. But RX-51 has not right Ctrl nor Shift therefore
    // pressing Ctrl+Shift will switch to previous layout, not to the next one.

    // For RX-51 device there is a lot of restrictions if more than one layout is
    // is configured at the same time because some modifiers and special cases are
    // handled by hildon layer (especially with eight-level layout):
    //  - settings may be done from terminal only (GUI doesn't and won't support it)
    //  - virtual symbol table is not updated according to current layout
    //  - for unknown reasons the eight-level layout (nordic,ru) works properly
    //    only if it's configured as first layout (e.g. "ru,us,cz" not "us,cz,ru")
    //    otherwise it's not possible to access levels 5-8
    //  - Ctrl+Space related problems:
    //     - If eight-level layout is used as first layout one of eight-level layouts has to
    //       be also chosen in GUI - otherwise the Ctrl+Space "switch" is disabled
    //     - Ctrl+Space has no effect if only four-level layouts are chosen
    //       (don't forget the layout configured in GUI - despite of it's not reachable)
    //     - a few keys in 2nd layer could be mixed with other layouts when Ctrl+Space is "turned on" (why?)
    //       in case eight- and four-level layouts are configured simultaneously
    //     - Ctrl+Space is "turned on" by default and has to be "turned off" for four-level layouts
    //       in case eight- and four-level layouts are configured simultaneously
    //     - four-level layout on first place doesn't work at all when Ctrl+Space is "turned on"
    //       in case the 2nd, 3rd or 4th layout is eight-level layout
};

////////////////////////////////////////////////////////////////////////////////

partial alphanumeric_keys
xkb_symbols "us" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_4btns)"

    name[Group1] = "U.S. English";
};



partial alphanumeric_keys
xkb_symbols "pl" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_4btns)"

    name[Group1] = "Polish";
};



partial alphanumeric_keys
xkb_symbols "fise" {
    include "nokia_vndr/rx-51(nordic_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Finnish/Swedish";

    // 2. row
    key <AB09>	{ [	odiaeresis,	Odiaeresis,	exclam,		exclam		] };
    key <UP>	{ [	adiaeresis,	Adiaeresis,	question,	question	] };
};



partial alphanumeric_keys
xkb_symbols "dano" {
    include "nokia_vndr/rx-51(nordic_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Danish/Norwegian";

    // 2. row
    key <AB09>	{ [	oslash,		Oslash,		exclam,		exclam		] };
    key <UP>	{ [	ae,		AE,		question,	question	] };
};



partial alphanumeric_keys
xkb_symbols "nordic" {
    include "nokia_vndr/rx-51(nordic_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Danish/Finnish/Norwegian/Swedish";

    key.type[Group1] = "EIGHT_LEVEL_SEMIALPHABETIC";

    // 2. row
    key <AB09>	{ [	odiaeresis,	Odiaeresis,	exclam,		exclam,		oslash,		Oslash,		exclam,		exclam		] };
    key <UP>	{ [	adiaeresis,	Adiaeresis,	question,	question,	ae,		AE,		question,	question	] };
};



partial alphanumeric_keys
xkb_symbols "ptes" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Portuguese/Spanish";

    // 1. row
    key <AB08>	{ [	dead_acute,	dead_acute,	dead_grave,	dead_grave	] };

    // 2. row
    key <AC05>	{ [	g,		G,		exclamdown,	exclamdown	] };
    key <AC06>	{ [	h,		H,		exclam,		exclam		] };
    key <AC07>	{ [	j,		J,		questiondown,	questiondown	] };
    key <AC08>	{ [	k,		K,		question,	question	] };
    key <AC09>	{ [	l,		L,		dead_diaeresis,	dead_diaeresis	] };
    key <AB09>	{ [	ntilde,		Ntilde,		dead_tilde,	dead_tilde	] };
    key <UP>	{ [	ccedilla,	Ccedilla,	dead_circumflex,dead_circumflex	] };

    // 3. row
    key <AB01>	{ [	z,		Z,		parenleft,	parenleft	] };
    key <AB02>	{ [	x,		X,		parenright,	parenright 	] };
    key <AB03>	{ [	c,		C,		slash,		slash		] };
    key <AB04>	{ [	v,		V,		quotedbl,	quotedbl	] };
    key <AB05>	{ [	b,		B,		apostrophe,	apostrophe	] };
    key <AB06>	{ [	n,		N,		colon,		colon		] };
    key <AB07>	{ [	m,		M,		semicolon,	semicolon	] };
    key <LEFT>	{ [	period,		comma,		comma,		comma		] };
};



partial alphanumeric_keys
xkb_symbols "fr" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "French";

    // 1. row
    key <AD01>	{ [	a,		A,		1,		1		] };
    key <AD02>	{ [	z,		Z,		2,		2		] };
    key <AB08>	{ [	agrave,		Agrave,		ccedilla,	Ccedilla	] };

    // 2. row
    key <AC01>	{ [	q,		Q,		asterisk,	asterisk	] };
    key <AC02>	{ [	s,		S,		plus,		plus		] };
    key <AC03>	{ [	d,		D,		numbersign,	numbersign	] };
    key <AC04>	{ [	f,		F,		minus,  	minus		] };
    key <AC05>	{ [	g,		G,		underscore,	underscore	] };
    key <AC06>	{ [	h,		H,		exclam,		exclam		] };
    key <AC07>	{ [	j,		J,		question,	question	] };
    key <AC08>	{ [	k,		K,		colon,		colon		] };
    key <AC09>	{ [	l,		L,		dead_circumflex,dead_circumflex	] };
    key <AB09>	{ [	m,		M,		ugrave,		Ugrave		] };
    key <UP>	{ [	eacute,		Eacute,		egrave,		Egrave		] };

    // 3. row
    key <AB01>	{ [	w,		W,		EuroSign,       EuroSign	] };
    key <AB03>	{ [	c,		C,		parenleft,	parenleft	] };
    key <AB04>	{ [	v,		V,		parenright,	parenright	] };
    key <AB05>	{ [	b,		B,		slash,		slash		] };
    key <AB07>	{ [	comma,		comma,		apostrophe,	apostrophe	] };
    key <LEFT>	{ [	semicolon,	period,		period,		period		] };
};



partial alphanumeric_keys
xkb_symbols "de" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "German";

    // 1. row
    key <AD06>	{ [	z,		Z,		6,		6		] };
    key <AB08>	{ [	udiaeresis,	Udiaeresis,	ssharp,		ssharp		] };

    // 2. row
    key <AC08>	{ [	k,		K,		semicolon,	semicolon	] };
    key <AC09>	{ [	l,		L,		colon,		colon		] };
    key <AB09>	{ [	odiaeresis,	Odiaeresis,	exclam,		exclam		] };
    key <UP>	{ [	adiaeresis,	Adiaeresis,	question,	question	] };

    // 3. row
    key <AB01>	{ [	y,		Y,		EuroSign,	EuroSign	] };
    key <AB03>	{ [	c,		C,		equal,		equal		] };
    key <LEFT>	{ [	period,		comma,		comma,		comma		] };
};



partial alphanumeric_keys
xkb_symbols "ch" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Swiss";

    // 1. row
    key <AD06>	{ [	z,		Z,		6,		6		] };
    key <AB08>	{ [	udiaeresis,	Udiaeresis,	egrave,		Egrave		] };

    // 2. row
    key <AC06>	{ [	h,		H,		equal,		equal		] };
    key <AC07>	{ [	j,		J,		parenleft,	parenleft	] };
    key <AC08>	{ [	k,		K,		parenright,	parenright	] };
    key <AC09>	{ [	l,		L,		colon,		colon		] };
    key <AB09>	{ [	odiaeresis,	Odiaeresis,	eacute,		Aacute		] };
    key <UP>	{ [	adiaeresis,	Adiaeresis,	agrave,		Agrave		] };

    // 3. row
    key <AB01>	{ [	y,		Y,		question,	question	] };
    key <AB02>	{ [	x,		X,		exclam,		exclam		] };
    key <AB03>	{ [	c,		C,		ccedilla,	Ccedilla	] };
    key <LEFT>	{ [	period,		comma,		comma,		comma		] };
};



// Levels 5-8 are Russian, levels 1-4 US English, for shortcut reasons.
partial alphanumeric_keys
xkb_symbols "ru" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Russian";

    key.type[Group1] = "EIGHT_LEVEL_SEMIALPHABETIC";

    // 1. row
    key <AD01>	{ [	q,		Q,		1,			1,			Cyrillic_shorti,	Cyrillic_SHORTI,	1,			1			] };
    key <AD02>	{ [	w,		W,		2,			2,			Cyrillic_tse,		Cyrillic_TSE,		2,			2			] };
    key <AD03>	{ [	e,		E,		3,			3,			Cyrillic_u,		Cyrillic_U,		3,			3			] };
    key <AD04>	{ [	r,		R,		4,			4,			Cyrillic_ka,		Cyrillic_KA,		4,			4			] };
    key <AD05>	{ [	t,		T,		5,			5,			Cyrillic_ie,		Cyrillic_IE,		5,			5			] };
    key <AD06>	{ [	y,		Y,		6,			6,			Cyrillic_en,		Cyrillic_EN,		6,			6			] };
    key <AD07>	{ [	u,		U,		7,			7,			Cyrillic_ghe,		Cyrillic_GHE,		7,			7			] };
    key <AD08>	{ [	i,		I,		8,			8,			Cyrillic_sha,		Cyrillic_SHA,		8,			8			] };
    key <AD09>	{ [	o,		O,		9,			9,			Cyrillic_shcha,		Cyrillic_SHCHA,		9,			9			] };
    key <AD10>	{ [	p,		P,		0,			0,			Cyrillic_ze,		Cyrillic_ZE,		0,			0			] };
    key <AB08>  { [	Cyrillic_ha,	Cyrillic_HA,	Cyrillic_hardsign,	Cyrillic_HARDSIGN,	Cyrillic_ha,		Cyrillic_HA,		Cyrillic_hardsign,	Cyrillic_HARDSIGN	] };

    // 2. row
    key <AC01>	{ [	a,		A,		asterisk,		asterisk,		Cyrillic_ef,		Cyrillic_EF,		asterisk,		asterisk		] };
    key <AC02>	{ [	s,		S,		plus,			plus,			Cyrillic_yeru,		Cyrillic_YERU,		plus,			plus			] };
    key <AC03>	{ [	d,		D,		numbersign,		numbersign,		Cyrillic_ve,		Cyrillic_VE,		numbersign,		numbersign		] };
    key <AC04>	{ [	f,		F,		minus,			minus,			Cyrillic_a,		Cyrillic_A,		minus,			minus			] };
    key <AC05>	{ [	g,		G,		underscore,		underscore,		Cyrillic_pe,		Cyrillic_PE,		underscore,		underscore		] };
    key <AC06>	{ [	h,		H,		exclam,			exclam,			Cyrillic_er,		Cyrillic_ER,		exclam,			exclam			] };
    key <AC07>	{ [	j,		J,		question,		question,		Cyrillic_o,		Cyrillic_O,		question,		question		] };
    key <AC08>	{ [	k,		K,		semicolon,		semicolon,		Cyrillic_el,		Cyrillic_EL,		semicolon,		semicolon		] };
    key <AC09>	{ [	l,		L,		colon,			colon,			Cyrillic_de,		Cyrillic_DE,		colon,			colon			] };
    key <AB09>	{ [	comma,		comma,		comma,			comma,			Cyrillic_zhe,		Cyrillic_ZHE,		comma,			comma			] };
    key <UP>	{ [	period,		period,		period,			period,			Cyrillic_e,		Cyrillic_E,		period,			period			] };

    // 3. row
    key <AB01>	{ [	z,		Z,		dollar,			dollar,			Cyrillic_ya,		Cyrillic_YA,		dollar,			dollar			] };
    key <AB02>	{ [	x,		X,		EuroSign,		EuroSign,		Cyrillic_che,		Cyrillic_CHE,		EuroSign,		EuroSign		] };
    key <AB03>	{ [	c,		C,		slash,			slash,			Cyrillic_es,		Cyrillic_ES,		slash,			slash			] };
    key <AB04>	{ [	v,		V,		parenleft,		parenleft,		Cyrillic_em,		Cyrillic_EM,		parenleft,		parenleft		] };
    key <AB05>	{ [	b,		B,		parenright,		parenright,		Cyrillic_i,		Cyrillic_I,		parenright,		parenright		] };
    key <AB06>	{ [	n,		N,		quotedbl,		quotedbl,		Cyrillic_te,		Cyrillic_TE,		quotedbl,		quotedbl		] };
    key <AB07>	{ [	m,		M,		apostrophe,		apostrophe,		Cyrillic_softsign,	Cyrillic_SOFTSIGN,	apostrophe,		apostrophe		] };
    key <LEFT>	{ [	Cyrillic_be,	Cyrillic_BE,	Cyrillic_yu,		Cyrillic_YU,		Cyrillic_be,		Cyrillic_BE,		Cyrillic_yu,		Cyrillic_YU		] };
};



partial alphanumeric_keys
xkb_symbols "it" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Italian";

    // 1. row
    key <AB08>	{ [	egrave,		Egrave,		eacute,		Eacute		] };

    // 2. row
    key <AC06>	{ [	h,		H,		semicolon,	semicolon	] };
    key <AC07>	{ [	j,		J,		colon,		colon		] };
    key <AC08>	{ [	k,		K,		exclam,		exclam		] };
    key <AC09>	{ [	l,		L,		question,	question	] };
    key <AB09>	{ [	ograve,		Ograve,		igrave,		Igrave		] };
    key <UP>	{ [	agrave,		Agrave,		ugrave,		Ugrave		] };

    // 3. row
    key <AB01>	{ [	z,		Z,		EuroSign,	EuroSign	] };
    key <AB02>	{ [	x,		X,		parenleft,	parenleft	] };
    key <AB03>	{ [	c,		C,		parenright,	parenright	] };
    key <LEFT>	{ [	period,		comma,		comma,		comma		] };
};



partial alphanumeric_keys
xkb_symbols "cz" {
    include "nokia_vndr/rx-51(english_base)"
    include "nokia_vndr/rx-51(arrows_2btns)"

    name[Group1] = "Czech";

    // 1. row
    key <AD06>	{ [	z,		Z,		6,		6		] };
    key <AB08>	{ [	dead_acute,	dead_acute,	sterling,	sterling	] };

    // 2. row
    key <AC08>	{ [	k,		K,		semicolon,	semicolon	] };
    key <AC09>	{ [	l,		L,		colon,		colon		] };
    key <AB09>	{ [	uring,		Uring,		EuroSign,	EuroSign	] };
    key <UP>	{ [	dead_caron,	dead_caron,	dollar,		dollar		] };

    // 3. row
    key <AB01>	{ [	y,		Y,		equal,		equal		] };
    key <AB02>	{ [	x,		X,		slash,		slash		] };
    key <AB03>	{ [	c,		C,		backslash,	backslash	] };
    key <AB04>	{ [	v,		V,		apostrophe,	apostrophe	] };
    key <AB05>	{ [	b,		B,		quotedbl,	quotedbl	] };
    key <AB06>	{ [	n,		N,		exclam,		exclam		] };
    key <AB07>	{ [	m,		M,		question,	question	] };
    key <LEFT>	{ [	period,		comma,		comma,		comma		] };
};

partial alphanumeric_keys
xkb_symbols "cz_qwerty" {
    include "nokia_vndr/rx-51(cz)"

    name[Group1] = "Czech - qwerty";

    // Do not use the layout "cz_qwerty" directly if it is the only layout and compat rules enabled.
    // There is one compat rule that converts "cz_qwerty" to "pc+cz(qwerty)" which is not correct for RX-51.
    // Use either the layout "cz(qwerty)" or the general "cz" with variant "qwerty".

    // 1. row
    key <AD06>	{ [	y,		Y,		6,		6		] };

    // 3. row
    key <AB01>	{ [	z,		Z,		percent,	percent		] };
};



////////////////////////////////////////////////////////////////////////////////

partial hidden alphanumeric_keys
xkb_symbols "nordic_base" {
    include "nokia_vndr/rx-51(english_base)"

    // 1. row
    key <AB08>	{ [	aring,		Aring,		equal,		equal		] };

    // 2. row
    key <AC08>	{ [	k,		K,		semicolon,	semicolon	] };
    key <AC09>	{ [	l,		L,		colon,		colon		] };

    // 3. row
    key <AB01>	{ [	z,		Z,		EuroSign,	EuroSign	] };
    key <AB03>	{ [	c,		C,		sterling,	sterling	] };
    key <LEFT>	{ [	period,		comma,		comma,		comma		] };
};

partial hidden alphanumeric_keys
xkb_symbols "english_base" {

    // 1. row
    key <AD01>	{ [	q,		Q,		1,		1		] };
    key <AD02>	{ [	w,		W,		2,		2		] };
    key <AD03>	{ [	e,		E,		3,		3		] };
    key <AD04>	{ [	r,		R,		4,		4		] };
    key <AD05>	{ [	t,		T,		5,		5		] };
    key <AD06>	{ [	y,		Y,		6,		6		] };
    key <AD07>	{ [	u,		U,		7,		7		] };
    key <AD08>	{ [	i,		I,		8,		8		] };
    key <AD09>	{ [	o,		O,		9,		9		] };
    key <AD10>	{ [	p,		P,		0,		0		] };
    key <AB08>	{ [	comma,		semicolon,	equal,		equal		] };

    // 2. row
    key <AC01>	{ [	a,		A,		asterisk,	asterisk	] };
    key <AC02>	{ [	s,		S,		plus,		plus		] };
    key <AC03>	{ [	d,		D,		numbersign,	numbersign	] };
    key <AC04>	{ [	f,		F,		minus,		minus		] };
    key <AC05>	{ [	g,		G,		underscore,	bracketleft	] };
    key <AC06>	{ [	h,		H,		parenleft,	braceleft	] };
    key <AC07>	{ [	j,		J,		parenright,	braceright	] };
    key <AC08>	{ [	k,		K,		ampersand,	bracketright	] };
    key <AC09>	{ [	l,		L,		exclam,		exclam		] };
    key <AB09>	{ [	period,		colon,		period, 	question	] };

    // 3. row
    key <AB01>	{ [	z,		Z,		percent,	sterling	] };
    key <AB02>	{ [	x,		X,		dollar,		dollar		] };
    key <AB03>	{ [	c,		C,		bar,		EuroSign	] };
    key <AB04>	{ [	v,		V,		slash,		slash		] };
    key <AB05>	{ [	b,		B,		backslash,	backslash	] };
    key <AB06>	{ [	n,		N,		quotedbl,	quotedbl	] };
    key <AB07>	{ [	m,		M,		apostrophe,	apostrophe	] };
    key <SPCE>	{ [	space,		space,		space,		at		] };
};

partial hidden alphanumeric_keys
xkb_symbols "common_keys" {
    // all other common keys

    key <BKSP>	{ [	BackSpace,	Delete,	BackSpace,	Delete	] };
    key <TAB>	{ [	Tab		] };

    // broken UI spec.
    key <RTRN>	{ [	KP_Enter	] };

    key <KPEN>	{ [	Return		] };
    key <ESC>	{ [	Escape		] };

    key <FK01>	{ [	F1	] };
    key <FK02>	{ [	F2	] };
    key <FK03>	{ [	F3	] };
    key <FK04>	{ [	F4	] };
    key <FK05>	{ [	F5	] };
    key <FK06>	{ [	F6	] };

    // Swap +/- keys intentionally. The VOL+/VOL- keys are located physically
    // on left/right and up/down in landscape/portrait orientation. This does
    // not feel natural for the user and therefore we want the VOL+/VOL- keys
    // map to -/+.
    //
    // The only exception is an active call in portrait mode where we want to
    // use the real meanings of the keys. This special case and management of
    // +/- keys in general is handled in maemo-statusmenu-volume.
    key <FK07>	{ [	F8	] };
    key <FK08>	{ [	F7	] };

    key <FK09>	{ [	F9	] };
    key <FK10>	{ [	F10	] };
    key <FK11>	{ [	F11	] };
};

partial hidden alphanumeric_keys modifier_keys
xkb_symbols "modifiers" {
    // Shift switches between current level and level+1
    key <LFSH>	{
	type[Group1] = "ONE_LEVEL",
	symbols[Group1] = [	Shift_L	]
    };
    modifier_map Shift { Shift_L };

    // Fn+Ctrl virtual symbol table (Multi_key)
    // Ctrl+Space switches between 1st and 5th level (hardcoded in hildon)
    key <LCTL>	{
	type[Group1] = "FOUR_LEVEL",
	symbols[Group1] = [	Control_L,	Control_L,	Multi_key,	Multi_key	]
    };
    modifier_map Control { Control_L };

    // Fn key (right alt) switches to 3rd level
    include "level3(ralt_switch)"
};

partial hidden alphanumeric_keys
xkb_symbols "arrows_2btns" {
    // rx-51 specific arrows mapping
    // normal 2nd level must not be enumerated to allow text selection with Shift key
    key <DOWN>	{ type[Group1] = "PC_FN_LEVEL2", symbols[Group1] = [	Left,	Up	] };
    key <RGHT>	{ type[Group1] = "PC_FN_LEVEL2", symbols[Group1] = [	Right,	Down	] };
};

partial hidden alphanumeric_keys
xkb_symbols "arrows_4btns" {
    key <UP>	{ type[Group1] = "FOUR_LEVEL",symbols[Group1] = [ Up, asciicircum, PageUp, PageUp ] };
    key <LEFT>	{ type[Group1] = "FOUR_LEVEL", symbols[Group1] = [ Left, less, Escape, Escape ] };
    key <DOWN>	{ type[Group1] = "FOUR_LEVEL", symbols[Group1] = [ Down, asciitilde, PageDown, PageDown ] };
    key <RGHT>	{ type[Group1] = "FOUR_LEVEL", symbols[Group1] = [ Right, greater, Tab, Tab ] };
};
