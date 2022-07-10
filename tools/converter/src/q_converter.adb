
with ADA.UNCHECKED_CONVERSION;


package body Q_CONVERTER is

  function F_GET_VALUE (V_HEX : LONG_LONG_INTEGER) return T_TYPE is
  
    V_VALUE : T_TYPE;
    
    function F_GET_VALUE is new ADA.UNCHECKED_CONVERSION
       (SOURCE => LONG_LONG_INTEGER,
        TARGET => T_TYPE);
  
  begin
  
    V_VALUE := F_GET_VALUE (V_HEX);
    
    return V_VALUE;
  
  end F_GET_VALUE;

end Q_CONVERTER;
