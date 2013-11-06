//
//  StringForNSUserDefaults.h
//  SmartClient
//
//  Created by sun on 13-11-6.
//  Copyright (c) 2013年 searching. All rights reserved.
//

#ifndef SmartClient_StringForNSUserDefaults_h
#define SmartClient_StringForNSUserDefaults_h

//decode
#define STR_ONE_DECODE          @"decode_one_barcode"
#define STR_RECT_DECODE         @"decode_rect_barcode"
#define STR_QR_DECODE           @"decode_qr_barcode"
#define STR_SOUND               @"decode_sound"
#define STR_VIBRATE             @"decode_vibrate"

//other settings
#define STR_MAC                 @"send_mac"
#define STR_LOG                 @"enable_log"
#define STR_SERIAL              @"serial_number"

#define STR_ENABLE_GPS          @"enable_gps"
#define STR_STARTUP_GPS         @"startup_gps"
#define STR_GPS_TIME            @"gps_time"
#define STR_GPS_DISTANCE        @"gps_distance"

//notification
#define STR_NF_ACTIVE           @"nf_active"
#define STR_NF_SOUND            @"nf_sound"
#define STR_NF_VIBRATE          @"nf_vibrate"
#define STR_NF_TIME             @"nf_time"
#define STR_NF_SERVER           @"nf_server"
#define STR_NF_PORT             @"nf_port"
#define STR_NF_USER             @"nf_user"
#define STR_NF_PASSWORD         @"nf_password"


#define SWITCH_INIT(N)      (N) = [[UISwitch alloc] initWithFrame:CGRectZero]
#define SWITCH_ACTION(N)    [(N) addTarget:self action:@selector(_switchChanged:) forControlEvents:UIControlEventValueChanged]

#endif
