public with sharing class StringArrayTest {

    public static List<String> generateStringArray(Integer n) {
    
        List<String> res = new List<String>();
    
        if( n > 0 ) {
            for(Integer i = 0; i < n; i++)
                res.add('Test ' + i );
        }

        return res ;
    }
}