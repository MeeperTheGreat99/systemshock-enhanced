#include "lg.h"
#include "newmfd.h"
#include "mfdfunc.h"

extern errtype mfd_keypad_input(MFD *m, char b_num);

static uchar keypad_keys[12] = { FALSE };
static uchar keypad_keys_last[12] = { FALSE };

void keypad_down(char code) {
	keypad_keys[code] = TRUE;
}

void keypad_up(char code) {
	keypad_keys[code] = FALSE;
}

void keypad_flush(void) {
	for (int i = 0; i < 12; i++) {
		if (keypad_keys[i] && !keypad_keys_last[i]) {
			extern MFD mfd[];
			int m = NUM_MFDS;
			if (mfd_yield_func(MFD_KEYPAD_FUNC, &m)) {
				mfd_keypad_input(&mfd[m], i);
			}
		}
	}
	
	memcpy(keypad_keys_last, keypad_keys, sizeof(keypad_keys));
	memset(keypad_keys, FALSE, sizeof(keypad_keys));
}