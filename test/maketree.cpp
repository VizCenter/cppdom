#include <assert.h>
#include <cppdom/cppdom.h>
#include <testHelpers.h>


/** 
* Test application to test creating a document from scratch
*/
int main()
{
   // Create the basic context and document to work on
   // - All nodes need to have an associated context
   //   we will just define one here at the beginning and use it
   //   the entire way through
   cppdom::ContextPtr ctx( new cppdom::Context );
   cppdom::Document doc("Document Root", ctx );   
   
   // What it should look like
   // - Root
   //   - Element1: attrib1:1, attrib2:two
   //       cdata: This is element1
   //   - Element2:
   //      - Element3: attrib1:attrib1
   cppdom::NodePtr element1(new cppdom::Node("Element1", ctx));
   cppdom::NodePtr element2(new cppdom::Node("Element2", ctx));
   cppdom::NodePtr element3(new cppdom::Node("Element3", ctx));
   cppdom::NodePtr element1_cdata(new cppdom::Node("Element1-cdata", ctx));

   // Now add element 1
   // - Also set it's attributes
   doc.addChild(element1);
   element1->setAttribute("attrib1", 1);
   element1->setAttribute("attrib2", "two");
   //element1->addChild(element1_cdata);

   // Cdata must have it's type set
   // then set the actual contents of the cdata
   element1_cdata->setType(cppdom::xml_nt_cdata);
   element1_cdata->setCdata("This is element1");

   // Add a couple of nested nodes and set the attributes
   doc.addChild(element2);
   element2->addChild(element3);
   element3->setAttribute("attrib1", "attrib1");

   // Dump the tree to the screen
   testHelpers::dump_node(doc);

   // Write the document out to a file
   doc.save(std::cout);
   std::string filename = "maketree.xml";
   doc.saveFile(filename);   
}
