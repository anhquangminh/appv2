import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Map<String, IconData> faIcons = {

  // Navigation
  'home': FontAwesomeIcons.house,
  'bars': FontAwesomeIcons.bars,
  'ellipsis': FontAwesomeIcons.ellipsis,
  'arrowLeft': FontAwesomeIcons.arrowLeft,
  'arrowRight': FontAwesomeIcons.arrowRight,
  'arrowUp': FontAwesomeIcons.arrowUp,
  'arrowDown': FontAwesomeIcons.arrowDown,
  'chevronLeft': FontAwesomeIcons.chevronLeft,
  'chevronRight': FontAwesomeIcons.chevronRight,
  'chevronUp': FontAwesomeIcons.chevronUp,
  'chevronDown': FontAwesomeIcons.chevronDown,

  // CRUD
  'plus': FontAwesomeIcons.plus,
  'minus': FontAwesomeIcons.minus,
  'pen': FontAwesomeIcons.pen,
  'trash': FontAwesomeIcons.trash,
  'copy': FontAwesomeIcons.copy,
  'paste': FontAwesomeIcons.paste,
  'save': FontAwesomeIcons.floppyDisk,
  'upload': FontAwesomeIcons.upload,
  'download': FontAwesomeIcons.download,
  'share': FontAwesomeIcons.share,
  'print': FontAwesomeIcons.print,

  // Search / filter
  'search': FontAwesomeIcons.magnifyingGlass,
  'filter': FontAwesomeIcons.filter,
  'sort': FontAwesomeIcons.sort,
  'sliders': FontAwesomeIcons.sliders,

  // User
  'user': FontAwesomeIcons.user,
  'users': FontAwesomeIcons.users,
  'userTie': FontAwesomeIcons.userTie,
  'userPlus': FontAwesomeIcons.userPlus,
  'userMinus': FontAwesomeIcons.userMinus,
  'userCheck': FontAwesomeIcons.userCheck,
  'userGear': FontAwesomeIcons.userGear,

  // Security
  'lock': FontAwesomeIcons.lock,
  'unlock': FontAwesomeIcons.unlock,
  'key': FontAwesomeIcons.key,
  'shield': FontAwesomeIcons.shieldHalved,
  'fingerprint': FontAwesomeIcons.fingerprint,

  // Notification
  'bell': FontAwesomeIcons.bell,
  'comment': FontAwesomeIcons.comment,
  'comments': FontAwesomeIcons.comments,
  'envelope': FontAwesomeIcons.envelope,
  'inbox': FontAwesomeIcons.inbox,

  // Files
  'file': FontAwesomeIcons.file,
  'fileLines': FontAwesomeIcons.fileLines,
  'filePdf': FontAwesomeIcons.filePdf,
  'fileExcel': FontAwesomeIcons.fileExcel,
  'fileWord': FontAwesomeIcons.fileWord,
  'fileImage': FontAwesomeIcons.fileImage,
  'fileArchive': FontAwesomeIcons.fileZipper,

  // Folder
  'folder': FontAwesomeIcons.folder,
  'folderOpen': FontAwesomeIcons.folderOpen,
  'folderPlus': FontAwesomeIcons.folderPlus,

  // Calendar / time
  'calendar': FontAwesomeIcons.calendar,
  'calendarDays': FontAwesomeIcons.calendarDays,
  'clock': FontAwesomeIcons.clock,
  'stopwatch': FontAwesomeIcons.stopwatch,

  // Settings
  'gear': FontAwesomeIcons.gear,
  'toolbox': FontAwesomeIcons.toolbox,
  'wrench': FontAwesomeIcons.wrench,

  // Charts
  'chartLine': FontAwesomeIcons.chartLine,
  'chartPie': FontAwesomeIcons.chartPie,
  'chartBar': FontAwesomeIcons.chartBar,
  'diagramProject': FontAwesomeIcons.diagramProject,

  // Business
  'building': FontAwesomeIcons.building,
  'briefcase': FontAwesomeIcons.briefcase,
  'store': FontAwesomeIcons.store,
  'industry': FontAwesomeIcons.industry,

  // Money
  'dollar': FontAwesomeIcons.dollarSign,
  'creditCard': FontAwesomeIcons.creditCard,
  'wallet': FontAwesomeIcons.wallet,
  'moneyBill': FontAwesomeIcons.moneyBill,

  // Transport
  'car': FontAwesomeIcons.car,
  'truck': FontAwesomeIcons.truck,
  'motorcycle': FontAwesomeIcons.motorcycle,
  'plane': FontAwesomeIcons.plane,
  'ship': FontAwesomeIcons.ship,

  // Location
  'map': FontAwesomeIcons.map,
  'mapPin': FontAwesomeIcons.mapPin,
  'locationDot': FontAwesomeIcons.locationDot,

  // Communication
  'phone': FontAwesomeIcons.phone,
  'mobile': FontAwesomeIcons.mobile,
  'wifi': FontAwesomeIcons.wifi,

  // Media
  'play': FontAwesomeIcons.play,
  'pause': FontAwesomeIcons.pause,
  'stop': FontAwesomeIcons.stop,
  'camera': FontAwesomeIcons.camera,
  'image': FontAwesomeIcons.image,

  // Status
  'check': FontAwesomeIcons.check,
  'xmark': FontAwesomeIcons.xmark,
  'circleCheck': FontAwesomeIcons.circleCheck,
  'circleXmark': FontAwesomeIcons.circleXmark,
  'triangleExclamation': FontAwesomeIcons.triangleExclamation,
  'circleInfo': FontAwesomeIcons.circleInfo,
  'circleQuestion': FontAwesomeIcons.circleQuestion,

  // Rating
  'star': FontAwesomeIcons.star,
  'heart': FontAwesomeIcons.heart,
  'thumbsUp': FontAwesomeIcons.thumbsUp,
  'thumbsDown': FontAwesomeIcons.thumbsDown,

  // Misc UI
  'tag': FontAwesomeIcons.tag,
  'tags': FontAwesomeIcons.tags,
  'bookmark': FontAwesomeIcons.bookmark,
  'link': FontAwesomeIcons.link,
  'paperclip': FontAwesomeIcons.paperclip,

  // Lists
  'list': FontAwesomeIcons.list,
  'listCheck': FontAwesomeIcons.listCheck,
  'table': FontAwesomeIcons.table,
  'tableCells': FontAwesomeIcons.tableCells,

  // Layout
  'grid': FontAwesomeIcons.grip,
  'expand': FontAwesomeIcons.expand,
  'compress': FontAwesomeIcons.compress,

  // System
  'database': FontAwesomeIcons.database,
  'server': FontAwesomeIcons.server,
  'cloud': FontAwesomeIcons.cloud,
  'cloudUpload': FontAwesomeIcons.cloudArrowUp,
  'cloudDownload': FontAwesomeIcons.cloudArrowDown,

  // Misc useful
  'globe': FontAwesomeIcons.globe,
  'language': FontAwesomeIcons.language,
  'qrcode': FontAwesomeIcons.qrcode,
  'barcode': FontAwesomeIcons.barcode,
  'calculator': FontAwesomeIcons.calculator,
  'clipboard': FontAwesomeIcons.clipboard,
  'clipboardCheck': FontAwesomeIcons.clipboardCheck,
  'clipboardList': FontAwesomeIcons.clipboardList,
};

final List<String> faIconNames = faIcons.keys.toList();

IconData getFaIcon(String? name) {
  return faIcons[name] ?? FontAwesomeIcons.question;
}