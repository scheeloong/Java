/*

Notes about annotations: 
Meta-annotations
    - Annotations that are applied under another annotation
        e.g. @Service is a meta-annotation for @Component
    - Can be combined to produce composed annotations
        e.g. @RestController = @Controller + @ResponseBody

Annotations: 

@Component <==> <bean id="className" class="packageName.className"></bean>
    Stereotypes: 
        @Repository 
            Marks as Persistent (Data) 
        @Service 
            Marks as Service
        @Controller
            Marks as Controller

@Scope

@Resource <==> 
    Looks for bean in .xml with same class name type and assigns it automatically

*/



package practiceOne.sequence
