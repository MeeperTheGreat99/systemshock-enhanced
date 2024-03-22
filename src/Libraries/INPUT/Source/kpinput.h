#ifndef KPINPUT_H
#define KPINPUT_H

extern short keypadKeysLast[12];
extern short keypadKeys[12];
extern const size_t keypadKeyCount;

void resetKeypadKeysLast(void);
void doMFDKeypadInput(void);
void setKeypadKeyPressed(int key, short pressed);
short getKeypadKeyPressed(int key);
int keypadIDXFromSDLKey(int keycode);

#endif