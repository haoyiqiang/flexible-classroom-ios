//
//  FcrAppUIEnums.swift
//  FlexibleClassroom
//
//  Created by Cavan on 2023/7/13.
//  Copyright © 2023 Agora. All rights reserved.
//

import AgoraClassroomSDK_iOS
import Foundation

typealias FcrAppUIRoomState = FcrAppRoomState
typealias FcrAppUILanguage  = FcrAppLanguage
typealias FcrAppUIRoomType  = FcrAppRoomType
typealias FcrAppUIRegion    = FcrAppRegion
typealias FcrAppUIUserRole  = FcrAppUserRole
typealias FcrAppUIDateType  = Calendar.Component

extension FcrAppUIRoomType {
    func text() -> String {
        switch self {
        case .oneToOne:     return "fcr_create_onetoone_title".localized()
        case .smallClass:   return "fcr_create_small_title".localized()
        case .lectureHall:  return "fcr_create_lecture_title".localized()
        case .proctor:      return "pt_home_page_scene_option_online_proctoring".localized()
        }
    }
    
    func toClassroomType() -> AgoraEduRoomType {
        switch self {
        case .oneToOne:     return .oneToOne
        case .lectureHall:  return .lecture
        case .smallClass:   return .small
        default:            fatalError()
        }
    }
}

extension FcrAppUIUserRole {
    func toClassroomType() -> AgoraEduUserRole {
        switch self {
        case .student:     return .student
        case .teacher:     return .teacher
        case .audience:    return .observer
        }
    }
}

extension FcrAppUILanguage {
    func text() -> String {
        switch self {
        case .zh_cn:
            return "fcr_settings_option_general_language_simplified".localized()
        case .en:
            return "fcr_settings_option_general_language_english".localized()
        }
    }
}

extension FcrAppUIMode {
    func text() -> String {
        switch self {
        case .light:
            return "settings_theme_light".localized()
        case .dark:
            return "settings_theme_dark".localized()
        }
    }
}

extension FcrAppUIRoomState {
    func text() -> String {
        switch self {
        case .unstarted:   return "fcr_room_list_upcoming".localized()
        case .inProgress:  return "fcr_room_list_live_now".localized()
        case .closed:      return "fcr_room_list_closed".localized()
        }
    }
}

enum FcrAppUIQuickStartSegmentOption {
    case join, create
}

enum FcrAppUISettingItem {
    enum GeneralItem: CaseIterable {
        case nickname
        case language
        case region
        case theme
        case closeAccount
        
        static func quickStartList() -> [GeneralItem] {
            return [.language,
                    .region,
                    .theme]
        }
    }
    
    enum AboutUsItem: CaseIterable {
        case privacy
        case terms
        case disclaimer
        case publish
    }
    
    case generalSetting([GeneralItem])
    case aboutUs([AboutUsItem])
}
