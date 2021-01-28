#include <vector>

#include "../CodeGenContext.h"
#include "CodeGenComplexType.h"

using namespace llvm;
using namespace std;

namespace stark
{
    CodeGenArrayComplexType::CodeGenArrayComplexType(std::string typeName, CodeGenContext *context) : CodeGenComplexType(formatv("array.{0}", typeName), context, true)
    {
        addMember("elements", typeName, context->getType(typeName)->getPointerTo());
        addMember("len", "int", context->getPrimaryType("int")->getType());
    }

    Value *CodeGenArrayComplexType::create(std::vector<Value *> values, FileLocation location)
    {
        // TODO
        return NULL;
    }

} // namespace stark