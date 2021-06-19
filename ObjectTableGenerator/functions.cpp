#include "functions.h"

void makeObjectTable(size_t stackNum,size_t objectNum) {

    std::ofstream outfile;
    outfile.open(FPATH, std::ofstream::out | std::ofstream::trunc);

    size_t i = 0;
    std::string object;
    std::random_device genRand;
    std::cout<<std::endl;
    std::cout<<"Object Table:\n";

    while(i < objectNum){

        for (size_t j = 0; j < stackNum; j++) {
            //Determine the Kind of Shape
            object = "";
            object += OBJTYPE[genRand() % OBJTYPELENGTH];

            if (isQuaddle(object))
                object += addObjectProperties(MAXQVALS, MAXQLENGTH, genRand);

            if (isPedastal(object))
                object += addObjectProperties(MAXPVALS, MAXPLENGTH, genRand);

            if (isShape(object))
                object += addObjectProperties(MAXSVALS, MAXSLENGTH, genRand);

            outfile << object << std::endl;
            std::cout << object << std::endl;
        }

        if(i != objectNum-1) {
            outfile << NEWOBJECT;
            std::cout << NEWOBJECT;
        }

        i++;
    }

    std::cout<< ENDTABLE;
    outfile << ENDTABLE;
    outfile.close();


}

std::string  addObjectProperties(const size_t arr[], const size_t arrayLength, std::random_device &gR) {

    std::string returnString;
    for(size_t z = 0; z < arrayLength; z++){
        returnString += std::to_string((gR() % arr[z] + 1));
    }

    return returnString;

}

std::string getFilePath(){

    std::string myPath;
    std::cout<<"Where do you want your object table to be saved?\n"
               "(Type \"defualt\" for the default path)\n";
    std::cin>>myPath;
    if (myPath == "" || myPath == "defualt" || myPath == " ")
        myPath = FPATH;
    
    return myPath;
    
}

std::string isDefaultGen(){

    bool goodInput = false;
    std::string myString;

    while(!goodInput) {

    std::cout<<"Do you want to do a default generation? Type 'y' or 'n'\n"
               "(50 random objects with a stack height of two)\n";
    std::cin>>myString;
    


        for (size_t i = 0; i < myString.length(); i++) {
            myString = toupper(myString[i]);

            if ((myString[i] > 'Z' || myString[i] < 'A') || myString.length() > 3) {
                goodInput = false;
                i = myString.length();
            }
            else
                goodInput = true;

        }

        if(!goodInput)
            std::cout<< "Bad Input, please re-enter your answer.\n";

    }

    return myString;
}

size_t getObjectNum(){

    bool goodInput = false;
    std::string objectCount;

    while(!goodInput) {
        std::cout << "How many objects do you want to make?\n";
        std::cin >> objectCount;

        goodInput = verifyNum(objectCount);
        
        if(!goodInput)
            std::cout<< "Bad Input, please re-enter your desired quantity.\n";

    }

    int returnVal = std::stoi(objectCount,nullptr,10);


    return (size_t) returnVal;

}

size_t getStackNum(){

    bool goodInput = false;
    std::string stackNum;

    while(!goodInput) {
        std::cout << "How many sub-objects high do you want in your objects?\n";
        std::cin >> stackNum;

        goodInput = verifyNum(stackNum);

        if(!goodInput)
            std::cout<< "Bad Input, please re-enter your desired quantity.\n";

    }

    int returnVal = std::stoi(stackNum,nullptr,10);


    return (size_t) returnVal;
    
    
}

bool verifyNum(std::string num){

    if(num == "" || num == " ")
        return false;

    for(size_t i = 0; i < num.length(); i++){

        if(num[i] < '0' || num[i] > '9')
            return false;

    }

    return true;

}

bool isQuaddle(std::string obj){

    return obj == "Q";
}

bool isPedastal(std::string obj){

    return obj == "P";
}

bool isShape(std::string obj){

    return obj == "S";
}

bool isDefault(std::string answer){

    return (answer == "YES" || answer == "Y");

}

void displayInstructions(){

    std:: string x;
    std::cout<<"Welcome!\nThis is an object table generator for Quaddle 2.0.1\n";
    std::cout<<"Here are the capabilities of the current Quaddle software:\n";

    std::cout<<"It can create three kinds of objects.\n"
               "(1) Quaddle 1.0\n"
               "(2) Pedastal Object\n"
               "(3) Shape Object\n";

    std::cin.ignore();

    std::cout<<"Quaddle Dimensions:\n(1) Body\n(2) Colour\n(3) Pattern\n(4)Arm Angle\n(5) Arm Ends\n";
    std::cout<<"Each Dimension has it's own varaint.\n";
    std::cout<<"Body: [1]Oblong [2]Pyramidal\n";
    std::cout<<"Colour: [1]More Red [2]More Orange\n";
    std::cout<<"Pattern: [1]Diamond [2]Checkered\n";
    std::cout<<"Arm Angle: [1]Bent Up [2]Bent Down\n";
    std::cout<<"Arm Ends: [1]Flat [2]Blunt [3]Pointed [4]Flared\n";

    std::cin.ignore();

    std::cout<<"Pedastal Dimensions:\n(1) Character\n(2) Arm Ends\n";
    std::cout<<"Each Dimension has it's own varaint.\n";
    std::cout<<"Arm Ends: [1]Flat [2]Blunt [3]Pointed [4]Flared\n";

    std::cin.ignore();

    std::cout<<"Shape Dimensions:\n(1) Shape";
    std::cout<<"Shape: [1]Cone [2]Pyramid [3]Hedra [4]pentagon [5]Gengon [6]Carrot [7]Spring\n";

}