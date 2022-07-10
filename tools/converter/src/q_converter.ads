package Q_CONVERTER is

generic

  type T_TYPE is private;
  
  function F_GET_VALUE (V_HEX : LONG_LONG_INTEGER) return T_TYPE;

end Q_CONVERTER;
