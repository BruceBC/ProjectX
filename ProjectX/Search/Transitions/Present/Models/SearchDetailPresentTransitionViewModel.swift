//
//  SearchDetailPresentTransitionViewModel.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/31/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit
import ProjectXCore

struct SearchDetailPresentTransitionViewModel {
    let name:           String
    let location:       String
    let description:    String
    let followerTitle:  String
    let postTitle:      String
    let followingTitle: String
    let followerCount:  String
    let postCount:      String
    let followingCount: String
    let image:          UIImage
    
    
    private init(
        name:           String,
        location:       String,
        description:    String,
        followerTitle:  String,
        postTitle:      String,
        followingTitle: String,
        followerCount:  String,
        postCount:      String,
        followingCount: String,
        image:          UIImage
    ) {
        self.name           = name
        self.location       = location
        self.description    = description
        self.followerTitle  = followerTitle
        self.postTitle      = postTitle
        self.followingTitle = followingTitle
        self.followerCount  = followerCount
        self.postCount      = postCount
        self.followingCount = followingCount
        self.image          = image
    }
}

extension SearchDetailPresentTransitionViewModel {
    static func makeModel(user: User, description: String, image: UIImage) -> SearchDetailPresentTransitionViewModel {
        let name           = "\(user.firstName.capitalizingFirstLetter()) \(user.lastName.capitalizingFirstLetter())"
        let location       = user.address.state.capitalizeEveryFirstLetter()
        let followerTitle  = user.twitter.followers.title
        let postTitle      = user.twitter.posts.title
        let followingTitle = user.twitter.following.title
        let followerCount  = user.twitter.followers.prettyCount
        let postCount      = user.twitter.posts.prettyCount
        let followingCount = user.twitter.following.prettyCount
        
        return SearchDetailPresentTransitionViewModel(
            name:           name,
            location:       location,
            description:    description,
            followerTitle:  followerTitle,
            postTitle:      postTitle,
            followingTitle: followingTitle,
            followerCount:  followerCount,
            postCount:      postCount,
            followingCount: followingCount,
            image:          image
        )
    }
}
