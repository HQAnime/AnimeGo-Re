import React, { Component } from 'react';
import { Container, Header, Left, Body, Right, Button, Icon, Title } from 'native-base';

export default class App extends Component {
  render() {
    return (
      <Container>
        <Header searchBar rounded>
          <Body>
            <Title>GoGoAnime</Title>
          </Body>
        </Header>
      </Container>
    );
  }
}