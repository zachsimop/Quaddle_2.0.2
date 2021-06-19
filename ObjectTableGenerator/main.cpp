#include "functions.h"


int main() {

    //displayInstructions();

    std::string filePath = getFilePath();

    std::string defaultString = isDefaultGen();


    if( isDefault(defaultString) )
        makeObjectTable(DEFAULTSTACKNUM,DEFAULTOBJECTNUM);
    else {
        size_t objectNum = getObjectNum();
        size_t stackNum = getStackNum();
        makeObjectTable(stackNum,objectNum);
    }

    return 0;
}
