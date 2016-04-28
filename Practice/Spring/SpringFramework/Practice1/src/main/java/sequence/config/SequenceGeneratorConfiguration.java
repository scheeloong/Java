package sequence.config; 
import org.springframework.context.annotation.Bean; 
import org.springframework.context.annotation.Configuration; 
import sequence.SequenceGenerator;

@Configuration
public class SequenceGeneratorConfiguration {
    // automatically generates bean based on method name, unless specified using @Bean(name="lala")
    @Bean
    public SequenceGenerator sequenceGenerator() {
        SequenceGenerator seqgen = new SequenceGenerator(); 
        seqgen.setPrefix("30");
        seqgen.setSuffix("A");
        seqgen.setInitial("100000");
        return seqgen; 
    }
}


/* Above is equivalent to 
<bean name="sequenceGenerator"  
    class = "sequence.SequenceGenerator">
    <property name="prefix">
        <value>30</value> 
     </property>
    <property name="prefix">
        <value>A</value> 
     </property>
    <property name="initial">
        <value>100000</value> 
     </property>


*/
