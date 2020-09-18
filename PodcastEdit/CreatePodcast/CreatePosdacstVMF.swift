//
//  CreatePosdacstVMF.swift
//  PodcastEdit
//
//  Created by Alexander Shoshiashvili on 16.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import SwiftyListKit

enum CreatePosdacstAction {
    case abnormalСontentItem
    case exportItem
    case trailerItem
    case description
    case nameAndIcon
    case download
    case link
    case editRecord
}

struct CreatePosdacstVMF {
    
    func sections(settings: CreatePodcastSettings) -> [TableListSection] {
        var viewModels: [TableItemViewModel] = []
        
        viewModels.append(getNameComponent(icon: settings.icon, name: settings.name))
        viewModels.append(getTextViewComponent(value: settings.descriptionText))
        
        if let file = settings.file {
            viewModels.append(getFileStateComponent(file: file))
        } else {
            viewModels.append(getEmptyStateComponent())
        }
        
        viewModels.append(contentsOf: getCheckboxItems(settings: settings))
        viewModels.append(getLinkComponent())
        
        let section = TableListSection(rows: viewModels)
        
        return [section]
    }
    
    // MARK: - Private
    
    // MARK: Name
    
    private func getNameComponent(icon: UIImage?, name: String) -> TableItemViewModel {
        let data = TextValueIcon(tag: CreatePosdacstAction.nameAndIcon, title: "Название", value: name, icon: icon)
        let item = TableItemViewModel(data: data, map: IconFieldTableViewCell.map)
        return item
    }
    
    // MARK: TextView
    
    private func getTextViewComponent(value: String) -> TableItemViewModel {
        let data = TextAndValue(tag: CreatePosdacstAction.description, title: "Описание подкаста", value: value)
        let item = TableItemViewModel(data: data, map: TextViewTableViewCell.map)
        return item
    }
    
    // MARK: Empty
    
    private func getEmptyStateComponent() -> TableItemViewModel {
        let data = TitleSubtitleAndValue(tag: CreatePosdacstAction.download,
                                         title: "Загрузите Ваш подкаст",
                                         subtitle: "Выберите готовый аудиофайл из вашего телефона и добавьте его",
                                         value: "Загрузить файл")
        let item = TableItemViewModel(data: data, map: EmptyStateTableViewCell.map)
        return item
    }
    
    // MARK: File
    
    private func getFileStateComponent(file: CreatePodcastSettings.File) -> TableItemViewModel {
        let data = TitleSubtitleAndValue(tag: CreatePosdacstAction.editRecord,
                                         title: file.name,
                                         subtitle: file.time.timeString,
                                         value: "Вы можете добавить таймкоды и скорректировать подкаст в режиме редактирования")
        let item = TableItemViewModel(data: data, map: FileTableViewCell.map)
        return item
    }
    
    // MARK: Checkbox
    
    private func getCheckboxItems(settings: CreatePodcastSettings) -> [TableItemViewModel] {
        let abnormalСontentItem = getCheckboxItem(tag: .abnormalСontentItem,
                                                   text: "Ненормативный контент",
                                                   isSelected: settings.allowAbnormalСontent)
        let exportItem = getCheckboxItem(tag: .exportItem,
                                         text: "Исключить эпизод из экспорта",
                                         isSelected: settings.excludeFromExport)
        let trailerItem = getCheckboxItem(tag: .trailerItem,
                                          text: "Трейлер подкаста",
                                          isSelected: settings.trailerForPodcast)
        return [abnormalСontentItem, exportItem, trailerItem]
    }
    
    private func getCheckboxItem(tag: CreatePosdacstAction, text: String, isSelected: Bool) -> TableItemViewModel {
        let data = TextAndValue(tag: tag, title: text, value: isSelected)
        let item = TableItemViewModel(data: data, map: CheckboxTableViewCell.map)
        return item
    }
    
    // MARK: Link
    
    private func getLinkComponent() -> TableItemViewModel {
        let data = TitleSubtitleAndValue(tag: CreatePosdacstAction.link,
                                         title: "Кому доступен данный подкаст",
                                         subtitle: "Всем пользователям",
                                         value: "При публикации записи с эпизодом, он становится доступным для всех пользователей")
        let item = TableItemViewModel(data: data, map: LinkTableViewCell.map)
        return item
    }

}
