package sequence;

import org.springframework.context.ApplicationContext; 
import org.springframework.context.support.GenericXmlApplicationContext; 

public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new GenericXmlApplicationContext("appContext.xml"); // the .xml file which specifies which java files to look for
        SequenceGenerator generator = (SequenceGenerator) context.getBean("sequenceGenerator");
        System.out.println(generator.getSequence()); 
        System.out.println(generator.getSequence()); 
    }
}
