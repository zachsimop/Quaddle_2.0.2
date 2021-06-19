#include <iostream>
#include <fstream>
#include <random>
#ifndef OBJECTTABLEGENERATOR_FUNCTIONS_H
#define OBJECTTABLEGENERATOR_FUNCTIONS_H


    const std::string FPATH = "C:\\Users\\zachs\\Documents\\Lab\\Quaddle_2.0.1\\Test Driver\\Patterns and Object Table\\myObjectTable.txt";

    const size_t OBJTYPELENGTH = 3;
    const size_t MAXQLENGTH = 5;
    const size_t MAXPLENGTH = 2;
    const size_t MAXSLENGTH = 1;

    const std::string OBJTYPE[OBJTYPELENGTH] = {"Q","P","S"};
    const size_t  MAXQVALS[MAXQLENGTH] = {2,2,2,2,4};
    const size_t  MAXPVALS[MAXPLENGTH] = {2,4};
    const size_t  MAXSVALS[MAXSLENGTH] = {7};

    const size_t DEFAULTOBJECTNUM = 30;
    const size_t DEFAULTSTACKNUM = 2;
    const std::string NEWOBJECT = "---\n";
    const std::string ENDTABLE = "***";


    void makeObjectTable(size_t stackNum, size_t objectNum);
    std::string addObjectProperties(const size_t arr[], const size_t arrayLength, std::random_device &gR);

    std::string getFilePath();
    std::string isDefaultGen();
    size_t getObjectNum();
    size_t getStackNum();

    bool verifyNum(std::string num);

    bool isQuaddle(std::string obj);
    bool isPedastal(std::string obj);
    bool isShape(std::string obj);
    bool isDefault(std::string answer);

    void displayInstructions();





#endif //OBJECTTABLEGENERATOR_FUNCTIONS_H
