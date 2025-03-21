enum PageName {
  nightMap,
  // nightOffers,
  nightSocial,
}

enum LoginRegistrationButtonType {
  filled,
  transparent,
}

enum CountryCode {
  al,
  ad,
  am,
  at,
  by,
  be,
  ba,
  bg,
  hr,
  cy,
  cz,
  dk,
  ee,
  fi,
  fr,
  ge,
  de,
  gr,
  hu,
  ic,
  ie,
  it,
  lv,
  li,
  lt,
  lu,
  mt,
  md,
  mc,
  me,
  nl,
  mk,
  no,
  pl,
  pt,
  ro,
  ru,
  sm,
  rs,
  sk,
  si,
  es,
  se,
  ch,
  ua,
  gb,
  us
}

enum PermissionState {
  noPermissions, // DEFAULT
  lowPermission, // GPS IS PERMITTED
  highPermission, // PRECISE LOCATION PERMITTED
  allPermissions, // ALWAYS USE GPS PERMITTED
}

enum MainOfferRedemptionPermisson {
  pending,
  granted,
  denied,
}

enum PartyStatus {
  unsure,
  yes,
  no,
}

enum OfferType {
  none,
  alwaysActive,
  redeemable,
}

enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
}

enum FriendFilterType { exclude, include }
