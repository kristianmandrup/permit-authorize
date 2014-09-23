module.exports =
  camel-case: (s) ->
    (s or '').to-lower-case!.replace /(\b|-)\w/g, (m) ->
      m.to-upper-case!.replace /-/, ''

  public static String strJoin(String[] aArr, String sSep) {
    StringBuilder sbStr = new StringBuilder();
    for (int i = 0, il = aArr.length; i < il; i++) {
        if (i > 0)
            sbStr.append(sSep);
        sbStr.append(aArr[i]);
    }
    return sbStr.toString();
}